package com.snow.business.cultural.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.snow.business.cultural.domain.CulturalCreativeComment;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.mapper.CulturalCreativeCommentMapper;
import com.snow.business.cultural.mapper.CulturalCreativeProductMapper;
import com.snow.business.cultural.service.ICulturalCreativeService;

/**
 * 文创服务实现
 */
@Service
public class CulturalCreativeServiceImpl implements ICulturalCreativeService
{
    @Autowired
    private CulturalCreativeProductMapper culturalCreativeProductMapper;

    @Autowired
    private CulturalCreativeCommentMapper culturalCreativeCommentMapper;

    @Override
    public CulturalCreativeProduct selectCulturalCreativeProductById(Long id)
    {
        return culturalCreativeProductMapper.selectCulturalCreativeProductById(id);
    }

    @Override
    public List<CulturalCreativeProduct> selectCulturalCreativeProductList(CulturalCreativeProduct product)
    {
        return culturalCreativeProductMapper.selectCulturalCreativeProductList(product);
    }

    @Override
    public Map<String, Object> selectCulturalCreativeFull(Long productId)
    {
        CulturalCreativeComment q = new CulturalCreativeComment();
        q.setProductId(productId);
        q.setStatus("0");
        q.setAuditStatus("1");

        Map<String, Object> data = new HashMap<>();
        data.put("product", selectCulturalCreativeProductById(productId));
        data.put("comments", culturalCreativeCommentMapper.selectCulturalCreativeCommentList(q));
        return data;
    }
}
