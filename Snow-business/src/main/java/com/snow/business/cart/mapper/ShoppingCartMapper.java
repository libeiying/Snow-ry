package com.snow.business.cart.mapper;

import java.math.BigDecimal;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.snow.business.cart.domain.ShoppingCart;

/**
 * 购物车 Mapper
 */
public interface ShoppingCartMapper
{
    public ShoppingCart selectShoppingCartByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    public ShoppingCart selectShoppingCartByUserAndProduct(@Param("userId") Long userId, @Param("productId") Long productId);

    public List<ShoppingCart> selectShoppingCartListByUserId(@Param("userId") Long userId);

    public List<ShoppingCart> selectCheckedListForUpdate(@Param("userId") Long userId);

    public int insertShoppingCart(ShoppingCart shoppingCart);

    public int updateShoppingCart(ShoppingCart shoppingCart);

    public int updateCheckedById(@Param("id") Long id, @Param("userId") Long userId, @Param("isChecked") String isChecked);

    public int updateCheckedAllByUserId(@Param("userId") Long userId, @Param("isChecked") String isChecked);

    public int updateQuantityById(@Param("id") Long id, @Param("userId") Long userId, @Param("quantity") Integer quantity);

    public int deleteShoppingCartById(@Param("id") Long id, @Param("userId") Long userId);

    public int deleteCheckedByUserId(@Param("userId") Long userId);

    public int markCheckedAsOrdered(@Param("userId") Long userId);

    public Integer selectCartCount(@Param("userId") Long userId);

    public BigDecimal selectCheckedTotalAmount(@Param("userId") Long userId);
}
