package com.snow.business.northeast.service;

import java.util.List;
import com.snow.business.northeast.domain.NortheastAttractionRelation;

public interface INortheastAttractionRelationService
{
    NortheastAttractionRelation selectNortheastAttractionRelationById(Long id);
    List<NortheastAttractionRelation> selectNortheastAttractionRelationList(NortheastAttractionRelation entity);
    int insertNortheastAttractionRelation(NortheastAttractionRelation entity);
    int updateNortheastAttractionRelation(NortheastAttractionRelation entity);
    int deleteNortheastAttractionRelationByIds(Long[] ids);
}
