package com.snow.web.controller.common;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.concurrent.TimeUnit;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FastByteArrayOutputStream;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.google.code.kaptcha.Producer;
import com.snow.common.config.RuoYiConfig;
import com.snow.common.constant.CacheConstants;
import com.snow.common.constant.Constants;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.redis.RedisCache;
import com.snow.common.utils.sign.Base64;
import com.snow.common.utils.uuid.IdUtils;
import com.snow.system.service.ISysConfigService;

/**
 * 验证码操作处理
 * 
 * @author ruoyi
 */
@RestController
public class CaptchaController
{
    @Resource(name = "captchaProducer")
    private Producer captchaProducer;

    @Resource(name = "captchaProducerMath")
    private Producer captchaProducerMath;

    @Autowired
    private RedisCache redisCache;
    
    @Autowired
    private ISysConfigService configService;
    /**
     * 生成验证码
     */
    @GetMapping("/captchaImage")
    public AjaxResult getCode(HttpServletResponse response) throws IOException
    {
        AjaxResult ajax = AjaxResult.success();
        boolean captchaEnabled = configService.selectCaptchaEnabled();
        ajax.put("captchaEnabled", captchaEnabled);
        if (!captchaEnabled)
        {
            return ajax;
        }

        try
        {
            // 保存验证码信息
            String uuid = IdUtils.simpleUUID();
            String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + uuid;

            String capStr = null, code = null;
            BufferedImage image = null;

            // 生成验证码
            String captchaType = RuoYiConfig.getCaptchaType();
            if (!"math".equals(captchaType) && !"char".equals(captchaType))
            {
                // 配置异常时兜底为字符验证码，避免直接 500
                captchaType = "char";
            }

            if ("math".equals(captchaType))
            {
                String capText = captchaProducerMath.createText();
                int at = capText.lastIndexOf("@");
                if (at <= 0 || at >= capText.length() - 1)
                {
                    return AjaxResult.error("验证码生成失败：表达式格式异常");
                }
                capStr = capText.substring(0, at);
                code = capText.substring(at + 1);
                image = captchaProducerMath.createImage(capStr);
            }
            else
            {
                capStr = code = captchaProducer.createText();
                image = captchaProducer.createImage(capStr);
            }

            if (image == null || code == null)
            {
                return AjaxResult.error("验证码生成失败：验证码配置异常");
            }

            redisCache.setCacheObject(verifyKey, code, Constants.CAPTCHA_EXPIRATION, TimeUnit.MINUTES);

            // 转换流信息写出
            FastByteArrayOutputStream os = new FastByteArrayOutputStream();
            ImageIO.write(image, "jpg", os);

            ajax.put("uuid", uuid);
            ajax.put("img", Base64.encode(os.toByteArray()));
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }

    }
}
