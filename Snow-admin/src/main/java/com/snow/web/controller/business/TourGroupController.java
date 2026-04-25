package com.snow.web.controller.business;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.snow.common.annotation.Anonymous;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;

/**
 * 用户端旅游团接口（简单CRUD + 详情组合返回）
 */
@RestController
@RequestMapping("/tour/groups")
public class TourGroupController extends BaseController
{
    @Autowired
    private ITourGroupService tourGroupService;

    /**
     * 列表（支持分页）
     */
    @Anonymous
    @GetMapping("/list")
    public TableDataInfo list(TourGroup tourGroup)
    {
        startPage();
        return getDataTable(tourGroupService.selectTourGroupList(tourGroup));
    }

    /**
     * 主表详情
     */
    @Anonymous
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(tourGroupService.selectTourGroupById(id));
    }

    /**
     * 主表+详情（用户端详情页用）
     */
    @Anonymous
    @GetMapping("/{id}/full")
    public AjaxResult getFull(@PathVariable("id") Long id)
    {
        Map<String, Object> data = tourGroupService.selectTourGroupFull(id);
        return success(data);
    }

    /**
     * 新增（主表+详情）
     */
    @PostMapping
    public AjaxResult add(@RequestBody TourGroupSaveReq req)
    {
        return toAjax(tourGroupService.insertTourGroup(req.getGroup(), req.getDetail()));
    }

    /**
     * 修改（主表+详情）
     */
    @PutMapping
    public AjaxResult edit(@RequestBody TourGroupSaveReq req)
    {
        return toAjax(tourGroupService.updateTourGroup(req.getGroup(), req.getDetail()));
    }

    /**
     * 删除（批量）
     */
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

