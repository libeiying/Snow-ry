package com.snow.business.northeast.mapper;

import java.util.List;
import com.snow.business.northeast.domain.NortheastRouteTemplate;

public interface NortheastRouteTemplateMapper
{
    NortheastRouteTemplate selectNortheastRouteTemplateById(Long id);

    List<NortheastRouteTemplate> selectNortheastRouteTemplateList(NortheastRouteTemplate entity);

    int insertNortheastRouteTemplate(NortheastRouteTemplate entity);

    int updateNortheastRouteTemplate(NortheastRouteTemplate entity);

    int deleteNortheastRouteTemplateById(Long id);

    int deleteNortheastRouteTemplateByIds(Long[] ids);
}
