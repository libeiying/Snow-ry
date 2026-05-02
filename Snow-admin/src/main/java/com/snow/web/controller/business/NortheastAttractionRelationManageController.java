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
import com.snow.business.northeast.domain.NortheastAttractionRelation;
import com.snow.business.northeast.service.INortheastAttractionRelationService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;

@RestController
@RequestMapping("/business/northeastAttractionRelation")
public class NortheastAttractionRelationManageController extends BaseController
{
    @Autowired
    private INortheastAttractionRelationService relationService;

    @PreAuthorize("@ss.hasPermi('business:northeastAttractionRelation:list')")
    @GetMapping("/list")
    public TableDataInfo list(NortheastAttractionRelation entity)
    {
        startPage();
        return getDataTable(relationService.selectNortheastAttractionRelationList(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttractionRelation:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(relationService.selectNortheastAttractionRelationById(id));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttractionRelation:add')")
    @Log(title = "东北景点关系管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NortheastAttractionRelation entity)
    {
        return toAjax(relationService.insertNortheastAttractionRelation(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttractionRelation:edit')")
    @Log(title = "东北景点关系管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody NortheastAttractionRelation entity)
    {
        return toAjax(relationService.updateNortheastAttractionRelation(entity));
    }

    @PreAuthorize("@ss.hasPermi('business:northeastAttractionRelation:remove')")
    @Log(title = "东北景点关系管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(relationService.deleteNortheastAttractionRelationByIds(ids));
    }
}
