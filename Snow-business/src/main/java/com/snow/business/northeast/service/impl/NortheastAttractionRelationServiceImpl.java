package com.snow.business.northeast.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.snow.business.northeast.domain.NortheastAttractionRelation;
import com.snow.business.northeast.mapper.NortheastAttractionRelationMapper;
import com.snow.business.northeast.service.INortheastAttractionRelationService;

@Service
public class NortheastAttractionRelationServiceImpl implements INortheastAttractionRelationService
{
    @Autowired
    private NortheastAttractionRelationMapper relationMapper;

    @Override
    public NortheastAttractionRelation selectNortheastAttractionRelationById(Long id)
    {
        return relationMapper.selectNortheastAttractionRelationById(id);
    }

    @Override
    public List<NortheastAttractionRelation> selectNortheastAttractionRelationList(NortheastAttractionRelation entity)
    {
        return relationMapper.selectNortheastAttractionRelationList(entity);
    }

    @Override
    public int insertNortheastAttractionRelation(NortheastAttractionRelation entity)
    {
        return relationMapper.insertNortheastAttractionRelation(entity);
    }

    @Override
    public int updateNortheastAttractionRelation(NortheastAttractionRelation entity)
    {
        return relationMapper.updateNortheastAttractionRelation(entity);
    }

    @Override
    public int deleteNortheastAttractionRelationByIds(Long[] ids)
    {
        return relationMapper.deleteNortheastAttractionRelationByIds(ids);
    }
}
