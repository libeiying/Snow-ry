package com.snow.business.northeast.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.snow.business.northeast.domain.NortheastRouteTemplate;
import com.snow.business.northeast.mapper.NortheastRouteTemplateMapper;
import com.snow.business.northeast.service.INortheastRouteTemplateService;

@Service
public class NortheastRouteTemplateServiceImpl implements INortheastRouteTemplateService
{
    @Autowired
    private NortheastRouteTemplateMapper routeTemplateMapper;

    @Override
    public NortheastRouteTemplate selectNortheastRouteTemplateById(Long id)
    {
        return routeTemplateMapper.selectNortheastRouteTemplateById(id);
    }

    @Override
    public List<NortheastRouteTemplate> selectNortheastRouteTemplateList(NortheastRouteTemplate entity)
    {
        return routeTemplateMapper.selectNortheastRouteTemplateList(entity);
    }

    @Override
    public int insertNortheastRouteTemplate(NortheastRouteTemplate entity)
    {
        return routeTemplateMapper.insertNortheastRouteTemplate(entity);
    }

    @Override
    public int updateNortheastRouteTemplate(NortheastRouteTemplate entity)
    {
        return routeTemplateMapper.updateNortheastRouteTemplate(entity);
    }

    @Override
    public int deleteNortheastRouteTemplateByIds(Long[] ids)
    {
        return routeTemplateMapper.deleteNortheastRouteTemplateByIds(ids);
    }
}
