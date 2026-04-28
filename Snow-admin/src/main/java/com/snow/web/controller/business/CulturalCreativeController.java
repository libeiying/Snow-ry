package com.snow.web.controller.business;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.domain.dto.CommentSubmitRequest;
import com.snow.business.cultural.service.ICulturalCreativeService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.config.RuoYiConfig;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.utils.file.FileUploadUtils;
import com.snow.common.utils.file.MimeTypeUtils;
import com.snow.framework.config.ServerConfig;

/**
 * 用户端文创接口
 */
@RestController
@RequestMapping("/cultural/creative")
public class CulturalCreativeController extends BaseController
{
    @Autowired
    private ICulturalCreativeService culturalCreativeService;

    @Autowired
    private ServerConfig serverConfig;

    /**
     * 列表（支持分页）
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(CulturalCreativeProduct product)
    {
        startPage();
        return getDataTable(culturalCreativeService.selectCulturalCreativeProductList(product));
    }

    /**
     * 详情（商品 + 评论）
     */
    @Anonymous
    @GetMapping("/{id}/full")
    public AjaxResult getFull(@PathVariable("id") Long id)
    {
        Map<String, Object> data = culturalCreativeService.selectCulturalCreativeFull(id);
        return success(data);
    }

    /**
     * 评论配图上传（仅图片，与通用上传一致，供用户端文创评价使用）
     */
    @Anonymous
    @PostMapping("/comment/upload")
    public AjaxResult uploadCommentImage(@RequestParam("file") MultipartFile file) throws Exception
    {
        String filePath = RuoYiConfig.getUploadPath();
        String fileName = FileUploadUtils.upload(filePath, file, MimeTypeUtils.IMAGE_EXTENSION);
        String url = serverConfig.getUrl() + fileName;
        AjaxResult ajax = AjaxResult.success();
        ajax.put("url", url);
        ajax.put("fileName", fileName);
        return ajax;
    }

    /**
     * 提交文创商品评论
     */
    @Anonymous
    @PostMapping("/{id}/comment")
    public AjaxResult submitComment(@PathVariable("id") Long id, @RequestBody CommentSubmitRequest body)
    {
        Long commentId = culturalCreativeService.submitCulturalCreativeComment(id, body);
        return success(commentId);
    }
}
