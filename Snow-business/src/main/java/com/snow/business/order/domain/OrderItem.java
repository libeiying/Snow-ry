package com.snow.business.order.domain;

import java.math.BigDecimal;
import com.snow.common.core.domain.BaseEntity;

/**
 * 订单明细对象 order_item
 */
public class OrderItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long orderId;
    private String orderNo;
    private Long userId;
    private Long productId;
    private String productCode;
    private String productTitle;
    private String productImage;
    private String skuText;
    private BigDecimal unitPrice;
    private Integer quantity;
    private BigDecimal itemAmount;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
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

    public BigDecimal getItemAmount()
    {
        return itemAmount;
    }

    public void setItemAmount(BigDecimal itemAmount)
    {
        this.itemAmount = itemAmount;
    }
}
