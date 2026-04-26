package com.snow.web.controller.business;

import com.snow.business.route.domain.NhRecommendRoute;
import com.snow.business.route.service.INhRecommendRouteService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/route/recommend")
public class NhRecommendRouteController extends BaseController
{
    @Autowired
    private INhRecommendRouteService nhRecommendRouteService;

    @Anonymous
    @GetMapping("/page")
    public TableDataInfo page(NhRecommendRoute nhRecommendRoute)
    {
        startPage();
        return getDataTable(nhRecommendRouteService.selectNhRecommendRouteList(nhRecommendRoute));
    }

    @Anonymous
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(nhRecommendRouteService.selectNhRecommendRouteById(id));
    }

    @Anonymous
    @Log(title = "RecommendRoute", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody NhRecommendRoute nhRecommendRoute)
    {
        return toAjax(nhRecommendRouteService.insertNhRecommendRoute(nhRecommendRoute));
    }

    @Anonymous
    @Log(title = "RecommendRoute", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}")
    public AjaxResult edit(@PathVariable("id") Long id, @RequestBody NhRecommendRoute nhRecommendRoute)
    {
        nhRecommendRoute.setId(id);
        return toAjax(nhRecommendRouteService.updateNhRecommendRoute(nhRecommendRoute));
    }

    @Anonymous
    @Log(title = "RecommendRoute", businessType = BusinessType.DELETE)
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable("id") Long id)
    {
        return toAjax(nhRecommendRouteService.deleteNhRecommendRouteById(id));
    }

    @Anonymous
    @Log(title = "RecommendRoute", businessType = BusinessType.DELETE)
    @PostMapping("/batch-delete")
    public AjaxResult batchDelete(@RequestBody BatchDeleteReq req)
    {
        return toAjax(nhRecommendRouteService.deleteNhRecommendRouteByIds(req.getIds()));
    }

    public static class BatchDeleteReq
    {
        private Long[] ids;

        public Long[] getIds()
        {
            return ids;
        }

        public void setIds(Long[] ids)
        {
            this.ids = ids;
        }
    }
}
