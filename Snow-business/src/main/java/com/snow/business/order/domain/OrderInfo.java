package com.snow.business.order.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.snow.common.annotation.Excel;
import com.snow.common.core.domain.BaseEntity;

/**
 * 订单主表对象 orders
 */
public class OrderInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    @Excel(name = "订单号")
    private String orderNo;
    @Excel(name = "用户ID")
    private Long userId;
    @Excel(name = "订单状态", readConverterExp = "0=待支付,1=已支付,2=已取消,3=已发货,4=已完成")
    private String orderStatus;
    @Excel(name = "支付状态", readConverterExp = "0=未支付,1=已支付")
    private String payStatus;
    @Excel(name = "订单总金额")
    private BigDecimal totalAmount;
    @Excel(name = "实付金额")
    private BigDecimal payAmount;
    @Excel(name = "收货人")
    private String receiverName;
    @Excel(name = "联系电话")
    private String receiverPhone;
    @Excel(name = "收货地址")
    private String receiverAddress;
    @Excel(name = "订单备注")
    private String remark;
    private Date payTime;
    private Date cancelTime;
    private Date shipTime;
    private Date finishTime;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
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

    public String getOrderStatus()
    {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus)
    {
        this.orderStatus = orderStatus;
    }

    public String getPayStatus()
    {
        return payStatus;
    }

    public void setPayStatus(String payStatus)
    {
        this.payStatus = payStatus;
    }

    public BigDecimal getTotalAmount()
    {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount)
    {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getPayAmount()
    {
        return payAmount;
    }

    public void setPayAmount(BigDecimal payAmount)
    {
        this.payAmount = payAmount;
    }

    public String getReceiverName()
    {
        return receiverName;
    }

    public void setReceiverName(String receiverName)
    {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone()
    {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone)
    {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverAddress()
    {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress)
    {
        this.receiverAddress = receiverAddress;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public Date getPayTime()
    {
        return payTime;
    }

    public void setPayTime(Date payTime)
    {
        this.payTime = payTime;
    }

    public Date getCancelTime()
    {
        return cancelTime;
    }

    public void setCancelTime(Date cancelTime)
    {
        this.cancelTime = cancelTime;
    }

    public Date getShipTime()
    {
        return shipTime;
    }

    public void setShipTime(Date shipTime)
    {
        this.shipTime = shipTime;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }
}
