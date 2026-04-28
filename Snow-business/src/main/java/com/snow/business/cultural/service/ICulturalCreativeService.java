package com.snow.business.cultural.service;

import java.util.List;
import java.util.Map;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.domain.dto.CommentSubmitRequest;

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

    /**
     * 用户提交文创商品评论（上架商品、内容校验；通过后立即展示）
     *
     * @return 新评论主键
     */
    public Long submitCulturalCreativeComment(Long productId, CommentSubmitRequest request);
}
