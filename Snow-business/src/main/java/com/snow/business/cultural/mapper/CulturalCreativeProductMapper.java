package com.snow.business.cultural.mapper;

import java.util.List;
import com.snow.business.cultural.domain.CulturalCreativeProduct;

/**
 * 文创商品主表 Mapper
 */
public interface CulturalCreativeProductMapper
{
    public CulturalCreativeProduct selectCulturalCreativeProductById(Long id);

    public List<CulturalCreativeProduct> selectCulturalCreativeProductList(CulturalCreativeProduct product);
}
