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
import com.snow.business.northeast.domain.NortheastAttraction;
import com.snow.business.northeast.service.INortheastAttractionService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;

@RestController
@RequestMapping("/business/northeastAttraction")
public class NortheastAttractionManageController extends BaseController
{
    @Autowired
    private INortheastAttractionService attractionService;

    @PreAuthorize("@ss.hasPermi('business:northeastAttraction:list')")
    @GetMapping("/list")
    public TableDataInfo list(NortheastAttraction entity)
    {
        startPage();
        return getDataTable(attractionService.selectNortheastAttractionList(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttraction:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(attractionService.selectNortheastAttractionById(id));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttraction:add')")
    @Log(title = "东北景点管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NortheastAttraction entity)
    {
        return toAjax(attractionService.insertNortheastAttraction(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttraction:edit')")
    @Log(title = "东北景点管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NortheastAttraction entity)
    {
        return toAjax(attractionService.updateNortheastAttraction(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttraction:remove')")
    @Log(title = "东北景点管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(attractionService.deleteNortheastAttractionByIds(ids));
    }
}
