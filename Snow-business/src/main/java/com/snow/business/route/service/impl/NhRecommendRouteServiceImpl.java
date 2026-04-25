package com.snow.business.route.service.impl;

import com.snow.business.route.domain.NhRecommendRoute;
import com.snow.business.route.mapper.NhRecommendRouteMapper;
import com.snow.business.route.service.INhRecommendRouteService;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.StringUtils;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NhRecommendRouteServiceImpl implements INhRecommendRouteService
{
    @Autowired
    private NhRecommendRouteMapper nhRecommendRouteMapper;

    @Override
    public NhRecommendRoute selectNhRecommendRouteById(Long id)
    {
        return nhRecommendRouteMapper.selectNhRecommendRouteById(id);
    }

    @Override
    public List<NhRecommendRoute> selectNhRecommendRouteList(NhRecommendRoute nhRecommendRoute)
    {
        return nhRecommendRouteMapper.selectNhRecommendRouteList(nhRecommendRoute);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertNhRecommendRoute(NhRecommendRoute nhRecommendRoute)
    {
        validateForSave(nhRecommendRoute);
        return nhRecommendRouteMapper.insertNhRecommendRoute(nhRecommendRoute);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateNhRecommendRoute(NhRecommendRoute nhRecommendRoute)
    {
        if (nhRecommendRoute.getId() == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        validateForSave(nhRecommendRoute);
        return nhRecommendRouteMapper.updateNhRecommendRoute(nhRecommendRoute);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhRecommendRouteById(Long id)
    {
        if (id == null)
        {
            throw new ServiceException("ID cannot be null");
        }
        return nhRecommendRouteMapper.deleteNhRecommendRouteById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteNhRecommendRouteByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            throw new ServiceException("IDs cannot be empty");
        }
        return nhRecommendRouteMapper.deleteNhRecommendRouteByIds(ids);
    }

    private void validateForSave(NhRecommendRoute nhRecommendRoute)
    {
        if (nhRecommendRoute == null)
        {
            throw new ServiceException("Request body cannot be null");
        }
        if (nhRecommendRoute.getRouteDate() == null)
        {
            throw new ServiceException("routeDate cannot be empty");
        }
        if (StringUtils.isEmpty(nhRecommendRoute.getSpotName()))
        {
            throw new ServiceException("spotName cannot be empty");
        }
    }
}
