package com.snow.framework.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.snow.common.config.AliOssProperties;
import com.snow.common.config.RuoYiConfig;
import com.snow.common.utils.StringUtils;
import com.snow.common.utils.file.FileUploadUtils;
import com.snow.common.utils.file.MimeTypeUtils;
import com.snow.common.utils.oss.AliOssUtil;

/**
 * 统一文件上传：启用 OSS 时写入阿里云并返回 https URL；否则写入本地 profile 目录并返回 /profile/... 路径。
 */
@Service
public class OssUploadService
{
    @Autowired
    private AliOssProperties aliOssProperties;

    @Autowired(required = false)
    private AliOssUtil aliOssUtil;

    private boolean useOss()
    {
        return aliOssProperties.isEnabled() && aliOssUtil != null;
    }

    /**
     * 通用上传（与 CommonController 默认扩展名一致）
     */
    public String uploadGeneric(MultipartFile file) throws Exception
    {
        return upload(file, MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION, RuoYiConfig.getUploadPath(), "upload");
    }

    /**
     * 仅图片（文创评论配图等）
     */
    public String uploadImage(MultipartFile file) throws Exception
    {
        return upload(file, MimeTypeUtils.IMAGE_EXTENSION, RuoYiConfig.getUploadPath(), "upload");
    }

    /**
     * 用户头像
     */
    public String uploadAvatar(MultipartFile file) throws Exception
    {
        return upload(file, MimeTypeUtils.IMAGE_EXTENSION, RuoYiConfig.getAvatarPath(), "avatar");
    }

    /**
     * @return OSS 返回完整 https URL；本地返回 /profile/... 相对路径（与原先 FileUploadUtils 一致）
     */
    public String upload(MultipartFile file, String[] allowedExtension, String localBaseDir, String ossFolder)
            throws Exception
    {
        if (useOss())
        {
            FileUploadUtils.assertAllowed(file, allowedExtension);
            String relativeName = FileUploadUtils.extractFilename(file);
            String objectKey = ossFolder + "/" + relativeName.replace('\\', '/');
            return aliOssUtil.upload(file.getBytes(), objectKey);
        }
        return FileUploadUtils.upload(localBaseDir, file, allowedExtension);
    }

    /**
     * 将存储路径转为浏览器可访问 URL（数据库可能存完整 OSS 地址或 /profile/...）
     */
    public String resolveAccessUrl(String serverBaseUrl, String storedPath)
    {
        if (StringUtils.isEmpty(storedPath))
        {
            return storedPath;
        }
        String p = storedPath.trim();
        if (p.startsWith("http://") || p.startsWith("https://"))
        {
            return p;
        }
        String base = StringUtils.isEmpty(serverBaseUrl) ? "" : serverBaseUrl.trim();
        return base + p;
    }

    /**
     * 对外接口统一输出的媒体 URL：数据库中为 OSS https 时原样返回；
     * 若为若依遗留路径 {@code /profile/avatar|upload/...}，在启用 OSS 时按与上传一致的对象键转为 OSS 公网地址；
     * 否则仍拼接应用服务器域名（本地存储）。
     */
    public String resolveForApi(String serverBaseUrl, String rawPath)
    {
        if (StringUtils.isEmpty(rawPath))
        {
            return rawPath;
        }
        String p = rawPath.trim();
        if (isBrowserAbsolute(p))
        {
            return p;
        }
        if (useOss() && aliOssUtil != null)
        {
            String key = profilePathToOssObjectKey(p);
            if (StringUtils.isNotEmpty(key))
            {
                return aliOssUtil.publicUrlForObjectKey(key);
            }
        }
        return legacyJoinServerWithProfilePath(serverBaseUrl, p);
    }

    public String resolveJsonArrayText(String serverBaseUrl, String jsonText)
    {
        if (StringUtils.isEmpty(jsonText))
        {
            return jsonText;
        }
        JSONArray arr;
        try
        {
            arr = JSON.parseArray(jsonText);
        }
        catch (Exception e)
        {
            return jsonText;
        }
        if (arr == null || arr.isEmpty())
        {
            return jsonText;
        }
        JSONArray resolved = resolveJsonArray(serverBaseUrl, arr);
        return resolved.toJSONString();
    }

    public JSONArray resolveJsonArray(String serverBaseUrl, JSONArray rawArray)
    {
        JSONArray out = new JSONArray();
        if (rawArray == null)
        {
            return out;
        }
        for (Object item : rawArray)
        {
            if (item instanceof String)
            {
                out.add(resolveForApi(serverBaseUrl, (String) item));
                continue;
            }
            if (item instanceof JSONObject)
            {
                JSONObject copy = new JSONObject();
                copy.putAll((JSONObject) item);
                rewriteJsonUrlField(copy, serverBaseUrl, "url");
                rewriteJsonUrlField(copy, serverBaseUrl, "path");
                rewriteJsonUrlField(copy, serverBaseUrl, "coverImage");
                out.add(copy);
                continue;
            }
            out.add(item);
        }
        return out;
    }

    private void rewriteJsonUrlField(JSONObject obj, String baseUrl, String field)
    {
        Object value = obj.get(field);
        if (value instanceof String)
        {
            obj.put(field, resolveForApi(baseUrl, (String) value));
        }
    }

    /** 若依本地库路径 /profile/... 与 OSS 对象键一致：去掉 /profile/ 前缀即为 objectKey（如 avatar/2026/05/xx.png）。 */
    private String profilePathToOssObjectKey(String rawPath)
    {
        String value = rawPath.trim().replace("\\", "/");
        int profileIndex = value.toLowerCase().indexOf("/profile/");
        if (profileIndex >= 0)
        {
            return trimObjectKey(value.substring(profileIndex + "/profile/".length()));
        }
        if (value.toLowerCase().startsWith("profile/"))
        {
            return trimObjectKey(value.substring("profile/".length()));
        }
        return null;
    }

    private static String trimObjectKey(String s)
    {
        if (StringUtils.isEmpty(s))
        {
            return s;
        }
        return s.replace('\\', '/').replaceAll("^/+", "").replaceAll("/+$", "");
    }

    private String legacyJoinServerWithProfilePath(String baseUrl, String rawPath)
    {
        String value = rawPath.trim().replace("\\", "/");
        if (isBrowserAbsolute(value))
        {
            return value;
        }
        if (value.startsWith("/profile/"))
        {
            return joinBase(baseUrl, value);
        }
        if (value.startsWith("profile/"))
        {
            return joinBase(baseUrl, "/" + value);
        }
        int profileIndex = value.toLowerCase().indexOf("/profile/");
        if (profileIndex >= 0)
        {
            return joinBase(baseUrl, value.substring(profileIndex));
        }
        return value;
    }

    private static boolean isBrowserAbsolute(String value)
    {
        String lower = value.toLowerCase();
        return lower.startsWith("http://")
                || lower.startsWith("https://")
                || lower.startsWith("//")
                || lower.startsWith("data:")
                || lower.startsWith("blob:");
    }

    private static String joinBase(String baseUrl, String path)
    {
        String b = StringUtils.isEmpty(baseUrl) ? "" : baseUrl.trim();
        String p = StringUtils.isEmpty(path) ? "" : path.trim();
        if (StringUtils.isEmpty(b))
        {
            return p;
        }
        if (b.endsWith("/") && p.startsWith("/"))
        {
            return b.substring(0, b.length() - 1) + p;
        }
        if (!b.endsWith("/") && !p.startsWith("/"))
        {
            return b + "/" + p;
        }
        return b + p;
    }
}
