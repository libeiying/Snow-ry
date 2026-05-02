package com.snow.business.northeast.service;

import java.util.List;
import com.snow.business.northeast.domain.NortheastAttraction;

public interface INortheastAttractionService
{
    NortheastAttraction selectNortheastAttractionById(Long id);
    List<NortheastAttraction> selectNortheastAttractionList(NortheastAttraction entity);
    int insertNortheastAttraction(NortheastAttraction entity);
    int updateNortheastAttraction(NortheastAttraction entity);
    int deleteNortheastAttractionByIds(Long[] ids);
}
