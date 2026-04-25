package com.snow.business.tour.mapper;

import java.util.List;
import com.snow.business.tour.domain.TourGroupDetail;

/**
 * 旅游团详情表 Mapper
 */
public interface TourGroupDetailMapper
{
    public TourGroupDetail selectTourGroupDetailById(Long id);

    public TourGroupDetail selectTourGroupDetailByGroupId(Long groupId);

    public List<TourGroupDetail> selectTourGroupDetailList(TourGroupDetail detail);

    public int insertTourGroupDetail(TourGroupDetail detail);

    public int updateTourGroupDetail(TourGroupDetail detail);

    public int deleteTourGroupDetailById(Long id);

    public int deleteTourGroupDetailByGroupIds(Long[] groupIds);
}

