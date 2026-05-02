package com.snow.common.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 阿里云 OSS 配置（snow.alioss）
 */
@Component
@ConfigurationProperties(prefix = "snow.alioss")
public class AliOssProperties
{
    /** 是否启用 OSS；关闭时使用本地 ruoyi.profile 目录上传 */
    private boolean enabled = true;

    /** 如 oss-cn-qingdao.aliyuncs.com */
    private String endpoint;

    private String accessKeyId;

    private String accessKeySecret;

    private String bucketName;

    /**
     * 可选：绑定域名或 CDN 根地址（不含末尾 /），设置后返回该前缀下的访问 URL
     */
    private String urlPrefix;

    public boolean isEnabled()
    {
        return enabled;
    }

    public void setEnabled(boolean enabled)
    {
        this.enabled = enabled;
    }

    public String getEndpoint()
    {
        return endpoint;
    }

    public void setEndpoint(String endpoint)
    {
        this.endpoint = endpoint;
    }

    public String getAccessKeyId()
    {
        return accessKeyId;
    }

    public void setAccessKeyId(String accessKeyId)
    {
        this.accessKeyId = normalizeSecret(accessKeyId);
    }

    public String getAccessKeySecret()
    {
        return accessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret)
    {
        this.accessKeySecret = normalizeSecret(accessKeySecret);
    }

    public String getBucketName()
    {
        return bucketName;
    }

    public void setBucketName(String bucketName)
    {
        this.bucketName = bucketName;
    }

    public String getUrlPrefix()
    {
        return urlPrefix;
    }

    public void setUrlPrefix(String urlPrefix)
    {
        this.urlPrefix = urlPrefix;
    }

    /**
     * 去掉首尾空白；去掉误写的 Windows 风格包裹符 {@code %...%}（会导致 OSS 报 Access Key Id 不存在）
     */
    private static String normalizeSecret(String raw)
    {
        if (raw == null)
        {
            return null;
        }
        String s = raw.trim();
        if (s.length() >= 2 && s.charAt(0) == '%' && s.charAt(s.length() - 1) == '%')
        {
            s = s.substring(1, s.length() - 1).trim();
        }
        return s;
    }
}
