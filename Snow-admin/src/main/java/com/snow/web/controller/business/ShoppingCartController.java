package com.snow.web.controller.business;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.common.annotation.Anonymous;
import com.snow.business.cart.domain.ShoppingCart;
import com.snow.business.cart.service.IShoppingCartService;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.domain.model.LoginUser;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.SecurityUtils;

/**
 * 用户端购物车接口
 */
@RestController
@Anonymous
@RequestMapping("/app/cart")
public class ShoppingCartController extends BaseController
{
    @Autowired
    private IShoppingCartService shoppingCartService;

    /**
     * 购物车列表
     */
    @GetMapping("/list")
    public AjaxResult list()
    {
        Long userId = getCurrentUserIdOrGuest();
        List<ShoppingCart> list = shoppingCartService.selectShoppingCartListByUserId(userId);
        return success(list);
    }

    /**
     * 购物车统计（数量、已选总金额）
     */
    @GetMapping("/summary")
    public AjaxResult summary()
    {
        Long userId = getCurrentUserIdOrGuest();
        Map<String, Object> data = shoppingCartService.selectCartSummary(userId);
        return success(data);
    }

    /**
     * 加入购物车
     */
    @PostMapping("/add")
    public AjaxResult add(@RequestBody CartAddReq req)
    {
        if (req == null || req.getProductId() == null)
        {
            throw new ServiceException("productId不能为空");
        }
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.addItem(userId, req.getProductId(), req.getQuantity()));
    }

    /**
     * 修改单条勾选
     */
    @PutMapping("/{id}/checked")
    public AjaxResult updateChecked(@PathVariable("id") Long id, @RequestBody CartCheckedReq req)
    {
        if (req == null || req.getIsChecked() == null)
        {
            throw new ServiceException("isChecked不能为空");
        }
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.updateItemChecked(userId, id, req.getIsChecked()));
    }

    /**
     * 全选/全不选
     */
    @PutMapping("/checked/all")
    public AjaxResult updateAllChecked(@RequestBody CartCheckedReq req)
    {
        if (req == null || req.getIsChecked() == null)
        {
            throw new ServiceException("isChecked不能为空");
        }
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.updateAllChecked(userId, req.getIsChecked()));
    }

    /**
     * 修改数量
     */
    @PutMapping("/{id}/quantity")
    public AjaxResult updateQuantity(@PathVariable("id") Long id, @RequestBody CartQuantityReq req)
    {
        if (req == null || req.getQuantity() == null)
        {
            throw new ServiceException("quantity不能为空");
        }
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.updateItemQuantity(userId, id, req.getQuantity()));
    }

    /**
     * 删除单条
     */
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable("id") Long id)
    {
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.deleteItem(userId, id));
    }

    /**
     * 清空已选
     */
    @DeleteMapping("/checked")
    public AjaxResult removeChecked()
    {
        Long userId = getCurrentUserIdOrGuest();
        return toAjax(shoppingCartService.deleteCheckedItems(userId));
    }

    public static class CartAddReq
    {
        private Long productId;
        private Integer quantity;

        public Long getProductId()
        {
            return productId;
        }

        public void setProductId(Long productId)
        {
            this.productId = productId;
        }

        public Integer getQuantity()
        {
            return quantity;
        }

        public void setQuantity(Integer quantity)
        {
            this.quantity = quantity;
        }
    }

    public static class CartCheckedReq
    {
        private String isChecked;

        public String getIsChecked()
        {
            return isChecked;
        }

        public void setIsChecked(String isChecked)
        {
            this.isChecked = isChecked;
        }
    }

    public static class CartQuantityReq
    {
        private Integer quantity;

        public Integer getQuantity()
        {
            return quantity;
        }

        public void setQuantity(Integer quantity)
        {
            this.quantity = quantity;
        }
    }

    private Long getCurrentUserIdOrGuest()
    {
        Authentication authentication = SecurityUtils.getAuthentication();
        if (authentication == null)
        {
            return 0L;
        }
        Object principal = authentication.getPrincipal();
        if (!(principal instanceof LoginUser))
        {
            return 0L;
        }
        return ((LoginUser) principal).getUserId();
    }
}
