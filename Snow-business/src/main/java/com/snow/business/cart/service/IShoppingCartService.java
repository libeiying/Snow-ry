package com.snow.business.cart.service;

import java.util.List;
import java.util.Map;
import com.snow.business.cart.domain.ShoppingCart;

/**
 * 购物车 Service
 */
public interface IShoppingCartService
{
    public List<ShoppingCart> selectShoppingCartListByUserId(Long userId);

    public int addItem(Long userId, Long productId, Integer quantity);

    public int updateItemChecked(Long userId, Long id, String isChecked);

    public int updateAllChecked(Long userId, String isChecked);

    public int updateItemQuantity(Long userId, Long id, Integer quantity);

    public int deleteItem(Long userId, Long id);

    public int deleteCheckedItems(Long userId);

    public Map<String, Object> selectCartSummary(Long userId);
}
