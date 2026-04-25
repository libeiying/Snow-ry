package com.snow.web.controller.business;

import java.util.Map;
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
import com.snow.business.tour.domain.TourGroup;
import com.snow.business.tour.domain.TourGroupDetail;
import com.snow.business.tour.service.ITourGroupService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;

/**
 * 旅游团管理
 */
@RestController
@RequestMapping("/business/tourGroup")
public class TourGroupManageController extends BaseController
{
    @Autowired
    private ITourGroupService tourGroupService;

    /**
     * 查询旅游团列表
     */
    @PreAuthorize("@ss.hasPermi('business:tourGroup:list')")
    @GetMapping("/list")
    public TableDataInfo list(TourGroup tourGroup)
    {
        startPage();
        return getDataTable(tourGroupService.selectTourGroupList(tourGroup));
    }

    /**
     * 查询旅游团详情（主表+详情表）
     */
    @PreAuthorize("@ss.hasPermi('business:tourGroup:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        Map<String, Object> data = tourGroupService.selectTourGroupFull(id);
        return success(data);
    }

    /**
     * 新增旅游团
     */
    @PreAuthorize("@ss.hasPermi('business:tourGroup:add')")
    @Log(title = "旅游团管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TourGroupSaveReq req)
    {
        return toAjax(tourGroupService.insertTourGroup(req.getGroup(), req.getDetail()));
    }

    /**
     * 修改旅游团
     */
    @PreAuthorize("@ss.hasPermi('business:tourGroup:edit')")
    @Log(title = "旅游团管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TourGroupSaveReq req)
    {
        return toAjax(tourGroupService.updateTourGroup(req.getGroup(), req.getDetail()));
    }

    /**
     * 删除旅游团
     */
    @PreAuthorize("@ss.hasPermi('business:tourGroup:remove')")
    @Log(title = "旅游团管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(tourGroupService.deleteTourGroupByIds(ids));
    }

    public static class TourGroupSaveReq
    {
        private TourGroup group;
        private TourGroupDetail detail;

        public TourGroup getGroup()
        {
            return group;
        }

        public void setGroup(TourGroup group)
        {
            this.group = group;
        }

        public TourGroupDetail getDetail()
        {
            return detail;
        }

        public void setDetail(TourGroupDetail detail)
        {
            this.detail = detail;
        }
    }
}
