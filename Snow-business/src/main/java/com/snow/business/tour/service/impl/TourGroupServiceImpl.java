package com.snow.business.tour.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.snow.business.tour.domain.TourGroup;
import com.snow.business.tour.domain.TourGroupDetail;
import com.snow.business.tour.mapper.TourGroupDetailMapper;
import com.snow.business.tour.mapper.TourGroupMapper;
import com.snow.business.tour.service.ITourGroupService;
import com.snow.common.core.text.Convert;

/**
 * 旅游团服务实现
 */
@Service
public class TourGroupServiceImpl implements ITourGroupService
{
    @Autowired
    private TourGroupMapper tourGroupMapper;

    @Autowired
    private TourGroupDetailMapper tourGroupDetailMapper;

    @Override
    public TourGroup selectTourGroupById(Long id)
    {
        return tourGroupMapper.selectTourGroupById(id);
    }

    @Override
    public List<TourGroup> selectTourGroupList(TourGroup tourGroup)
    {
        return tourGroupMapper.selectTourGroupList(tourGroup);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertTourGroup(TourGroup tourGroup, TourGroupDetail detail)
    {
        int rows = tourGroupMapper.insertTourGroup(tourGroup);
        if (detail != null)
        {
            detail.setGroupId(tourGroup.getId());
            tourGroupDetailMapper.insertTourGroupDetail(detail);
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateTourGroup(TourGroup tourGroup, TourGroupDetail detail)
    {
        int rows = tourGroupMapper.updateTourGroup(tourGroup);
        if (detail != null)
        {
            detail.setGroupId(tourGroup.getId());
            TourGroupDetail existing = tourGroupDetailMapper.selectTourGroupDetailByGroupId(tourGroup.getId());
            if (existing == null)
            {
                tourGroupDetailMapper.insertTourGroupDetail(detail);
            }
            else
            {
                tourGroupDetailMapper.updateTourGroupDetail(detail);
            }
        }
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteTourGroupByIds(Long[] ids)
    {
        Long[] groupIds = ids;
        if (groupIds != null && groupIds.length > 0)
        {
            tourGroupDetailMapper.deleteTourGroupDetailByGroupIds(groupIds);
        }
        return tourGroupMapper.deleteTourGroupByIds(ids);
    }

    @Override
    public TourGroupDetail selectDetailByGroupId(Long groupId)
    {
        return tourGroupDetailMapper.selectTourGroupDetailByGroupId(groupId);
    }

    @Override
    public Map<String, Object> selectTourGroupFull(Long groupId)
    {
        Map<String, Object> data = new HashMap<>();
        data.put("group", selectTourGroupById(groupId));
        data.put("detail", selectDetailByGroupId(groupId));
        return data;
    }

    /**
     * 兼容前端删除参数（逗号分隔）
     */
    public int deleteTourGroupByIds(String ids)
    {
        return deleteTourGroupByIds(Convert.toLongArray(ids));
    }
}

