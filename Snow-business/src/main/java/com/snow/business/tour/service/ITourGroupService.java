package com.snow.business.tour.service;

import java.util.List;
import java.util.Map;
import com.snow.business.tour.domain.TourGroup;
import com.snow.business.tour.domain.TourGroupDetail;

/**
 * 旅游团服务
 */
public interface ITourGroupService
{
    public TourGroup selectTourGroupById(Long id);

    public List<TourGroup> selectTourGroupList(TourGroup tourGroup);

    public int insertTourGroup(TourGroup tourGroup, TourGroupDetail detail);

    public int updateTourGroup(TourGroup tourGroup, TourGroupDetail detail);

    public int deleteTourGroupByIds(Long[] ids);

    public TourGroupDetail selectDetailByGroupId(Long groupId);

    /**
     * 返回主表+详情的组合数据（便于用户端详情页展示）
     */
    public Map<String, Object> selectTourGroupFull(Long groupId);
}

