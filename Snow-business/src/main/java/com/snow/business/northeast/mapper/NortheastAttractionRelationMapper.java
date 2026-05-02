package com.snow.business.northeast.mapper;

import java.util.List;
import com.snow.business.northeast.domain.NortheastAttractionRelation;

public interface NortheastAttractionRelationMapper
{
    NortheastAttractionRelation selectNortheastAttractionRelationById(Long id);

    List<NortheastAttractionRelation> selectNortheastAttractionRelationList(NortheastAttractionRelation entity);

    int insertNortheastAttractionRelation(NortheastAttractionRelation entity);

    int updateNortheastAttractionRelation(NortheastAttractionRelation entity);

    int deleteNortheastAttractionRelationById(Long id);

    int deleteNortheastAttractionRelationByIds(Long[] ids);
}
