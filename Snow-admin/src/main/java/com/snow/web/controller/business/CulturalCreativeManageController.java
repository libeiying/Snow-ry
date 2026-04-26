package com.snow.web.controller.business;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.service.ICulturalCreativeService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;
import com.snow.common.utils.SecurityUtils;
import com.snow.common.utils.poi.ExcelUtil;

/**
 * 文创商品管理
 */
@RestController
@RequestMapping("/business/culturalCreative")
public class CulturalCreativeManageController extends BaseController
{
    @Autowired
    private ICulturalCreativeService culturalCreativeService;

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:list')")
    @GetMapping("/list")
    public TableDataInfo list(CulturalCreativeProduct product)
    {
        startPage();
        return getDataTable(culturalCreativeService.selectCulturalCreativeProductList(product));
    }

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:export')")
    @Log(title = "文创管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, CulturalCreativeProduct product)
    {
        List<CulturalCreativeProduct> list = culturalCreativeService.selectCulturalCreativeProductList(product);
        ExcelUtil<CulturalCreativeProduct> util = new ExcelUtil<CulturalCreativeProduct>(CulturalCreativeProduct.class);
        util.exportExcel(response, list, "文创商品数据");
    }

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        Map<String, Object> data = culturalCreativeService.selectCulturalCreativeFull(id);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:add')")
    @Log(title = "文创管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody CulturalCreativeProduct product)
    {
        product.setCreateBy(SecurityUtils.getUsername());
        product.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(culturalCreativeService.insertCulturalCreativeProduct(product));
    }

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:edit')")
    @Log(title = "文创管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody CulturalCreativeProduct product)
    {
        product.setUpdateBy(SecurityUtils.getUsername());
        return toAjax(culturalCreativeService.updateCulturalCreativeProduct(product));
    }

    @PreAuthorize("@ss.hasPermi('business:culturalCreative:remove')")
    @Log(title = "文创管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(culturalCreativeService.deleteCulturalCreativeProductByIds(ids));
    }
}
