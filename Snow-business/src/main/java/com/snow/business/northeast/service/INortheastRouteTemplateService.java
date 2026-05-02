package com.snow.business.northeast.service;

import java.util.List;
import com.snow.business.northeast.domain.NortheastRouteTemplate;

public interface INortheastRouteTemplateService
{
    NortheastRouteTemplate selectNortheastRouteTemplateById(Long id);
    List<NortheastRouteTemplate> selectNortheastRouteTemplateList(NortheastRouteTemplate entity);
    int insertNortheastRouteTemplate(NortheastRouteTemplate entity);
    int updateNortheastRouteTemplate(NortheastRouteTemplate entity);
    int deleteNortheastRouteTemplateByIds(Long[] ids);
}
