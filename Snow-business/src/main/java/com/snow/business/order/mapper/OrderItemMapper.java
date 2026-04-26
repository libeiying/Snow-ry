package com.snow.business.order.mapper;

import java.util.List;
import com.snow.business.order.domain.OrderItem;

/**
 * 订单明细 Mapper
 */
public interface OrderItemMapper
{
    public int insertOrderItems(List<OrderItem> items);

    public List<OrderItem> selectOrderItemListByOrderNo(String orderNo);
}
