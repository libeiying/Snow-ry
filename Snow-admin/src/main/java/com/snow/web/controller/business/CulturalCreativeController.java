package com.snow.web.controller.business;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.service.ICulturalCreativeService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;

/**
 * 用户端文创接口
 */
@RestController
@RequestMapping("/cultural/creative")
public class CulturalCreativeController extends BaseController
{
    @Autowired
    private ICulturalCreativeService culturalCreativeService;

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
}
