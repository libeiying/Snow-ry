package com.snow.business.route.service;

import com.snow.business.route.domain.NhRecommendRoute;
import java.util.List;

public interface INhRecommendRouteService
{
    public NhRecommendRoute selectNhRecommendRouteById(Long id);

    public List<NhRecommendRoute> selectNhRecommendRouteList(NhRecommendRoute nhRecommendRoute);

    public int insertNhRecommendRoute(NhRecommendRoute nhRecommendRoute);

    public int updateNhRecommendRoute(NhRecommendRoute nhRecommendRoute);

    public int deleteNhRecommendRouteById(Long id);

    public int deleteNhRecommendRouteByIds(Long[] ids);
}
