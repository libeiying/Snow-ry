package com.snow.common.utils.oss;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import com.aliyun.oss.ClientException;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.OSSException;
import com.snow.common.config.AliOssProperties;
import com.snow.common.utils.StringUtils;

/**
 * 阿里云 OSS 上传（启用 snow.alioss.enabled=true 时生效）
 */
@Component
@ConditionalOnProperty(prefix = "snow.alioss", name = "enabled", havingValue = "true")
public class AliOssUtil
{
    private static final Logger log = LoggerFactory.getLogger(AliOssUtil.class);

    private final AliOssProperties props;

    public AliOssUtil(AliOssProperties props)
    {
        this.props = props;
    }

    /**
     * 上传对象并返回可访问 URL（https）
     *
     * @param bytes      文件内容
     * @param objectName OSS 对象键，如 upload/2026/05/02/xxx.png（不要用前导 /）
     */
    public String upload(byte[] bytes, String objectName) throws IOException
    {
        String accessKeyId = props.getAccessKeyId();
        String accessKeySecret = props.getAccessKeySecret();
        if (StringUtils.isEmpty(accessKeyId) || StringUtils.isEmpty(accessKeySecret))
        {
            throw new IOException(
                    "OSS 未配置 AccessKey：请设置环境变量 OSS_ACCESS_KEY_ID、OSS_ACCESS_KEY_SECRET（值为 LTAI 开头的 Id 与 Secret，不要带百分号包裹）");
        }

        String key = normalizeObjectKey(objectName);
        String endpoint = normalizeEndpoint(props.getEndpoint());
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
        try
        {
            ossClient.putObject(props.getBucketName(), key, new ByteArrayInputStream(bytes));
        }
        catch (OSSException oe)
        {
            log.error("OSS putObject OSSException: {} code={} requestId={}", oe.getErrorMessage(), oe.getErrorCode(),
                    oe.getRequestId());
            throw new IOException("OSS upload failed: " + oe.getErrorMessage(), oe);
        }
        catch (ClientException ce)
        {
            log.error("OSS putObject ClientException: {}", ce.getMessage());
            throw new IOException("OSS upload failed: " + ce.getMessage(), ce);
        }
        finally
        {
            ossClient.shutdown();
        }

        String url = buildPublicUrl(key, endpoint);
        log.info("文件上传 OSS: {}", url);
        return url;
    }

    /**
     * 根据已存在的对象键生成公网访问 URL（不上传），规则与 {@link #upload} 返回地址一致。
     */
    public String publicUrlForObjectKey(String objectName)
    {
        String key = normalizeObjectKey(objectName);
        if (StringUtils.isEmpty(key))
        {
            return key;
        }
        String endpoint = normalizeEndpoint(props.getEndpoint());
        return buildPublicUrl(key, endpoint);
    }

    private static String normalizeObjectKey(String objectName)
    {
        if (objectName == null)
        {
            return "";
        }
        return objectName.trim().replace('\\', '/').replaceAll("^/+", "");
    }

    private static String normalizeEndpoint(String endpoint)
    {
        if (StringUtils.isEmpty(endpoint))
        {
            return endpoint;
        }
        String e = endpoint.trim();
        if (e.startsWith("https://"))
        {
            e = e.substring(8);
        }
        else if (e.startsWith("http://"))
        {
            e = e.substring(7);
        }
        int slash = e.indexOf('/');
        if (slash > 0)
        {
            e = e.substring(0, slash);
        }
        return e;
    }

    private String buildPublicUrl(String objectKey, String endpoint)
    {
        if (StringUtils.isNotEmpty(props.getUrlPrefix()))
        {
            String base = props.getUrlPrefix().trim().replaceAll("/+$", "");
            return base + "/" + objectKey;
        }
        StringBuilder sb = new StringBuilder("https://");
        sb.append(props.getBucketName()).append(".").append(endpoint).append("/").append(objectKey);
        return sb.toString();
    }
}
