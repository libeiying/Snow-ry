package com.snow.web.controller.business.support;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.snow.common.utils.StringUtils;

/**
 * 统一处理后端返回的媒体路径，必要时拼接服务域名。
 */
public final class MediaUrlResolver
{
    private MediaUrlResolver()
    {
    }

    public static String resolve(String baseUrl, String rawPath)
    {
        if (StringUtils.isEmpty(rawPath))
        {
            return rawPath;
        }
        String value = normalizeRaw(rawPath);
        if (isAbsolute(value))
        {
            return value;
        }
        if (value.startsWith("/profile/"))
        {
            return join(baseUrl, value);
        }
        if (value.startsWith("profile/"))
        {
            return join(baseUrl, "/" + value);
        }
        int profileIndex = value.toLowerCase().indexOf("/profile/");
        if (profileIndex >= 0)
        {
            return join(baseUrl, value.substring(profileIndex));
        }
        return value;
    }

    public static String resolveJsonArrayText(String baseUrl, String jsonText)
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
        JSONArray resolved = resolveJsonArray(baseUrl, arr);
        return resolved.toJSONString();
    }

    public static JSONArray resolveJsonArray(String baseUrl, JSONArray rawArray)
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
                out.add(resolve(baseUrl, (String) item));
                continue;
            }
            if (item instanceof JSONObject)
            {
                JSONObject copy = new JSONObject();
                copy.putAll((JSONObject) item);
                rewriteField(copy, baseUrl, "url");
                rewriteField(copy, baseUrl, "path");
                rewriteField(copy, baseUrl, "coverImage");
                out.add(copy);
                continue;
            }
            out.add(item);
        }
        return out;
    }

    private static void rewriteField(JSONObject obj, String baseUrl, String field)
    {
        Object value = obj.get(field);
        if (value instanceof String)
        {
            obj.put(field, resolve(baseUrl, (String) value));
        }
    }

    private static String normalizeRaw(String raw)
    {
        return raw.trim().replace("\\", "/");
    }

    private static boolean isAbsolute(String value)
    {
        String lower = value.toLowerCase();
        return lower.startsWith("http://")
                || lower.startsWith("https://")
                || lower.startsWith("//")
                || lower.startsWith("data:")
                || lower.startsWith("blob:");
    }

    private static String join(String baseUrl, String path)
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
