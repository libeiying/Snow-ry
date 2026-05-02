package com.snow.business.order.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.snow.common.core.domain.BaseEntity;

/**
 * 支付流水对象 order_payment
 */
public class OrderPayment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long id;
    private String paymentNo;
    private String orderNo;
    private Long userId;
    private BigDecimal amount;
    private String payChannel;
    private String payStatus;
    private String transactionNo;
    private String callbackPayload;
    private String failReason;
    private Date paidTime;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getPaymentNo()
    {
        return paymentNo;
    }

    public void setPaymentNo(String paymentNo)
    {
        this.paymentNo = paymentNo;
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

    public BigDecimal getAmount()
    {
        return amount;
    }

    public void setAmount(BigDecimal amount)
    {
        this.amount = amount;
    }

    public String getPayChannel()
    {
        return payChannel;
    }

    public void setPayChannel(String payChannel)
    {
        this.payChannel = payChannel;
    }

    public String getPayStatus()
    {
        return payStatus;
    }

    public void setPayStatus(String payStatus)
    {
        this.payStatus = payStatus;
    }

    public String getTransactionNo()
    {
        return transactionNo;
    }

    public void setTransactionNo(String transactionNo)
    {
        this.transactionNo = transactionNo;
    }

    public String getCallbackPayload()
    {
        return callbackPayload;
    }

    public void setCallbackPayload(String callbackPayload)
    {
        this.callbackPayload = callbackPayload;
    }

    public String getFailReason()
    {
        return failReason;
    }

    public void setFailReason(String failReason)
    {
        this.failReason = failReason;
    }

    public Date getPaidTime()
    {
        return paidTime;
    }

    public void setPaidTime(Date paidTime)
    {
        this.paidTime = paidTime;
    }
}
