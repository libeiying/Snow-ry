package com.snow.business.cultural.service;

import java.util.List;
import java.util.Map;
import com.snow.business.cultural.domain.CulturalCreativeProduct;

/**
 * 文创服务
 */
public interface ICulturalCreativeService
{
    public CulturalCreativeProduct selectCulturalCreativeProductById(Long id);

    public List<CulturalCreativeProduct> selectCulturalCreativeProductList(CulturalCreativeProduct product);

    public Map<String, Object> selectCulturalCreativeFull(Long productId);

    public int insertCulturalCreativeProduct(CulturalCreativeProduct product);

    public int updateCulturalCreativeProduct(CulturalCreativeProduct product);

    public int deleteCulturalCreativeProductByIds(Long[] ids);
}
