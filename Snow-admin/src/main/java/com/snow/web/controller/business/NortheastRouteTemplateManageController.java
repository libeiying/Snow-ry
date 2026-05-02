package com.snow.web.controller.business;

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
import com.snow.business.northeast.domain.NortheastRouteTemplate;
import com.snow.business.northeast.service.INortheastRouteTemplateService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;

@RestController
@RequestMapping("/business/northeastRouteTemplate")
public class NortheastRouteTemplateManageController extends BaseController
{
    @Autowired
    private INortheastRouteTemplateService routeTemplateService;

    @PreAuthorize("@ss.hasPermi('business:northeastRouteTemplate:list')")
    @GetMapping("/list")
    public TableDataInfo list(NortheastRouteTemplate entity)
    {
        startPage();
        return getDataTable(routeTemplateService.selectNortheastRouteTemplateList(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastRouteTemplate:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(routeTemplateService.selectNortheastRouteTemplateById(id));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastRouteTemplate:add')")
    @Log(title = "东北路线模板管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NortheastRouteTemplate entity)
    {
        return toAjax(routeTemplateService.insertNortheastRouteTemplate(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastRouteTemplate:edit')")
    @Log(title = "东北路线模板管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NortheastRouteTemplate entity)
    {
        return toAjax(routeTemplateService.updateNortheastRouteTemplate(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastRouteTemplate:remove')")
    @Log(title = "东北路线模板管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(routeTemplateService.deleteNortheastRouteTemplateByIds(ids));
    }
}
