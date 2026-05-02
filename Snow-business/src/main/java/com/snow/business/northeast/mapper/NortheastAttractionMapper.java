package com.snow.business.northeast.mapper;

import java.util.List;
import com.snow.business.northeast.domain.NortheastAttraction;

public interface NortheastAttractionMapper
{
    NortheastAttraction selectNortheastAttractionById(Long id);

    List<NortheastAttraction> selectNortheastAttractionList(NortheastAttraction entity);

    int insertNortheastAttraction(NortheastAttraction entity);

    int updateNortheastAttraction(NortheastAttraction entity);

    int deleteNortheastAttractionById(Long id);

    int deleteNortheastAttractionByIds(Long[] ids);
}
