package com.snow.business.northeast.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.snow.business.northeast.domain.NortheastAttraction;
import com.snow.business.northeast.mapper.NortheastAttractionMapper;
import com.snow.business.northeast.service.INortheastAttractionService;

@Service
public class NortheastAttractionServiceImpl implements INortheastAttractionService
{
    @Autowired
    private NortheastAttractionMapper attractionMapper;

    @Override
    public NortheastAttraction selectNortheastAttractionById(Long id)
    {
        return attractionMapper.selectNortheastAttractionById(id);
    }

    @Override
    public List<NortheastAttraction> selectNortheastAttractionList(NortheastAttraction entity)
    {
        return attractionMapper.selectNortheastAttractionList(entity);
    }

    @Override
    public int insertNortheastAttraction(NortheastAttraction entity)
    {
        return attractionMapper.insertNortheastAttraction(entity);
    }

    @Override
    public int updateNortheastAttraction(NortheastAttraction entity)
    {
        return attractionMapper.updateNortheastAttraction(entity);
    }

    @Override
    public int deleteNortheastAttractionByIds(Long[] ids)
    {
        return attractionMapper.deleteNortheastAttractionByIds(ids);
    }
}
