package com.snow.business.cart.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 购物车单表对象 shopping_cart
 */
public class ShoppingCart extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private Long productId;
    private String productCode;
    private String productTitle;
    private String productSubTitle;
    private String productImage;
    private String skuText;
    private BigDecimal unitPrice;
    private Integer quantity;
    private String isChecked;
    private BigDecimal itemAmount;
    private String status;
    private String invalidReason;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getProductId()
    {
        return productId;
    }

    public void setProductId(Long productId)
    {
        this.productId = productId;
    }

    public String getProductCode()
    {
        return productCode;
    }

    public void setProductCode(String productCode)
    {
        this.productCode = productCode;
    }

    public String getProductTitle()
    {
        return productTitle;
    }

    public void setProductTitle(String productTitle)
    {
        this.productTitle = productTitle;
    }

    public String getProductSubTitle()
    {
        return productSubTitle;
    }

    public void setProductSubTitle(String productSubTitle)
    {
        this.productSubTitle = productSubTitle;
    }

    public String getProductImage()
    {
        return productImage;
    }

    public void setProductImage(String productImage)
    {
        this.productImage = productImage;
    }

    public String getSkuText()
    {
        return skuText;
    }

    public void setSkuText(String skuText)
    {
        this.skuText = skuText;
    }

    public BigDecimal getUnitPrice()
    {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice)
    {
        this.unitPrice = unitPrice;
    }

    public Integer getQuantity()
    {
        return quantity;
    }

    public void setQuantity(Integer quantity)
    {
        this.quantity = quantity;
    }

    public String getIsChecked()
    {
        return isChecked;
    }

    public void setIsChecked(String isChecked)
    {
        this.isChecked = isChecked;
    }

    public BigDecimal getItemAmount()
    {
        return itemAmount;
    }

    public void setItemAmount(BigDecimal itemAmount)
    {
        this.itemAmount = itemAmount;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getInvalidReason()
    {
        return invalidReason;
    }

    public void setInvalidReason(String invalidReason)
    {
        this.invalidReason = invalidReason;
    }
}
