package com.snow.business.order.enums;

/**
 * 订单状态
 */
public enum OrderStatus
{
    PENDING_PAY("0"),
    PAID("1"),
    CANCELED("2"),
    SHIPPED("3"),
    FINISHED("4");

    private final String code;

    OrderStatus(String code)
    {
        this.code = code;
    }

    public String getCode()
    {
        return code;
    }

    public static OrderStatus fromCode(String code)
    {
        for (OrderStatus value : values())
        {
            if (value.code.equals(code))
            {
                return value;
            }
        }
        return null;
    }
}
