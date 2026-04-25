package com.snow.business.tour.mapper;

import java.util.List;
import com.snow.business.tour.domain.TourGroup;

/**
 * 旅游团主表 Mapper
 */
public interface TourGroupMapper
{
    public TourGroup selectTourGroupById(Long id);

    public TourGroup selectTourGroupByGroupCode(String groupCode);

    public List<TourGroup> selectTourGroupList(TourGroup tourGroup);

    public int insertTourGroup(TourGroup tourGroup);

    public int updateTourGroup(TourGroup tourGroup);

    public int deleteTourGroupById(Long id);

    public int deleteTourGroupByIds(Long[] ids);
}

