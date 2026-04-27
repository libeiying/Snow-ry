package com.snow.business.cart.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.snow.business.cart.domain.ShoppingCart;
import com.snow.business.cart.mapper.ShoppingCartMapper;
import com.snow.business.cart.service.IShoppingCartService;
import com.snow.business.cultural.domain.CulturalCreativeProduct;
import com.snow.business.cultural.mapper.CulturalCreativeProductMapper;
import com.snow.business.tour.domain.TourGroup;
import com.snow.business.tour.mapper.TourGroupMapper;
import com.snow.common.exception.ServiceException;

/**
 * 购物车 Service 实现
 */
@Service
public class ShoppingCartServiceImpl implements IShoppingCartService
{
    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private CulturalCreativeProductMapper culturalCreativeProductMapper;

    @Autowired
    private TourGroupMapper tourGroupMapper;

    @Override
    public List<ShoppingCart> selectShoppingCartListByUserId(Long userId)
    {
        return shoppingCartMapper.selectShoppingCartListByUserId(userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addItem(Long userId, Long productId, Integer quantity)
    {
        int addCount = quantity == null ? 1 : quantity.intValue();
        if (addCount < 1)
        {
            throw new ServiceException("商品数量必须大于等于1");
        }

        CulturalCreativeProduct product = culturalCreativeProductMapper.selectCulturalCreativeProductById(productId);
        TourGroup tourGroup = null;
        if (product == null || !"0".equals(product.getStatus()))
        {
            // 兼容旅游团详情页：当文创商品不存在时，尝试按旅游团ID加购
            tourGroup = tourGroupMapper.selectTourGroupById(productId);
            if (tourGroup == null || !"0".equals(tourGroup.getStatus()))
            {
                throw new ServiceException("商品不存在或已下架");
            }
        }

        ShoppingCart oldItem = shoppingCartMapper.selectShoppingCartByUserAndProduct(userId, productId);
        if (oldItem == null)
        {
            ShoppingCart cart = new ShoppingCart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setProductCode(resolveProductCode(product, tourGroup));
            cart.setProductTitle(resolveProductTitle(product, tourGroup));
            cart.setProductSubTitle(resolveProductSubTitle(product, tourGroup));
            cart.setProductImage(resolveProductImage(product, tourGroup));
            cart.setSkuText(null);
            cart.setUnitPrice(resolvePrice(product, tourGroup));
            cart.setQuantity(addCount);
            cart.setIsChecked("1");
            cart.setStatus("0");
            cart.setInvalidReason(null);
            return shoppingCartMapper.insertShoppingCart(cart);
        }

        oldItem.setProductCode(resolveProductCode(product, tourGroup));
        oldItem.setProductTitle(resolveProductTitle(product, tourGroup));
        oldItem.setProductSubTitle(resolveProductSubTitle(product, tourGroup));
        oldItem.setProductImage(resolveProductImage(product, tourGroup));
        oldItem.setUnitPrice(resolvePrice(product, tourGroup));
        oldItem.setQuantity(oldItem.getQuantity() + addCount);
        oldItem.setIsChecked("1");
        oldItem.setStatus("0");
        oldItem.setInvalidReason(null);
        return shoppingCartMapper.updateShoppingCart(oldItem);
    }

    @Override
    public int updateItemChecked(Long userId, Long id, String isChecked)
    {
        if (!"0".equals(isChecked) && !"1".equals(isChecked))
        {
            throw new ServiceException("勾选状态参数错误");
        }
        return shoppingCartMapper.updateCheckedById(id, userId, isChecked);
    }

    @Override
    public int updateAllChecked(Long userId, String isChecked)
    {
        if (!"0".equals(isChecked) && !"1".equals(isChecked))
        {
            throw new ServiceException("勾选状态参数错误");
        }
        return shoppingCartMapper.updateCheckedAllByUserId(userId, isChecked);
    }

    @Override
    public int updateItemQuantity(Long userId, Long id, Integer quantity)
    {
        if (quantity == null || quantity < 1)
        {
            throw new ServiceException("商品数量必须大于等于1");
        }
        return shoppingCartMapper.updateQuantityById(id, userId, quantity);
    }

    @Override
    public int deleteItem(Long userId, Long id)
    {
        return shoppingCartMapper.deleteShoppingCartById(id, userId);
    }

    @Override
    public int deleteCheckedItems(Long userId)
    {
        return shoppingCartMapper.deleteCheckedByUserId(userId);
    }

    @Override
    public Map<String, Object> selectCartSummary(Long userId)
    {
        Map<String, Object> data = new HashMap<>();
        Integer count = shoppingCartMapper.selectCartCount(userId);
        BigDecimal checkedTotal = shoppingCartMapper.selectCheckedTotalAmount(userId);
        data.put("cartCount", count == null ? 0 : count);
        data.put("checkedTotalAmount", checkedTotal == null ? BigDecimal.ZERO : checkedTotal);
        return data;
    }

    private String resolveProductCode(CulturalCreativeProduct product, TourGroup tourGroup)
    {
        if (product != null)
        {
            return product.getProductCode();
        }
        String groupCode = tourGroup == null ? null : tourGroup.getGroupCode();
        if (groupCode == null || groupCode.trim().isEmpty())
        {
            return "TOUR-" + (tourGroup == null ? "" : tourGroup.getId());
        }
        return groupCode;
    }

    private String resolveProductTitle(CulturalCreativeProduct product, TourGroup tourGroup)
    {
        if (product != null)
        {
            return product.getTitle();
        }
        return tourGroup == null ? "" : tourGroup.getTitle();
    }

    private String resolveProductSubTitle(CulturalCreativeProduct product, TourGroup tourGroup)
    {
        if (product != null)
        {
            return product.getSubTitle();
        }
        return tourGroup == null ? null : tourGroup.getSubTitle();
    }

    private String resolveProductImage(CulturalCreativeProduct product, TourGroup tourGroup)
    {
        if (product != null)
        {
            return product.getCoverImage();
        }
        return tourGroup == null ? null : tourGroup.getCoverImage();
    }

    private BigDecimal resolvePrice(CulturalCreativeProduct product, TourGroup tourGroup)
    {
        if (product != null && product.getPrice() != null)
        {
            return product.getPrice();
        }
        if (tourGroup != null && tourGroup.getMinPrice() != null)
        {
            return tourGroup.getMinPrice();
        }
        return BigDecimal.ZERO;
    }
}
