package com.snow.business.order.enums;

import java.util.EnumMap;
import java.util.Map;

/**
 * 简单订单状态机：集中管理合法流转，避免业务代码散落判断。
 */
public class OrderStateMachine
{
    private static final Map<OrderStatus, Map<OrderEvent, OrderStatus>> TRANSITIONS = new EnumMap<>(OrderStatus.class);

    static
    {
        Map<OrderEvent, OrderStatus> pendingPay = new EnumMap<>(OrderEvent.class);
        pendingPay.put(OrderEvent.PAY, OrderStatus.PAID);
        pendingPay.put(OrderEvent.CANCEL, OrderStatus.CANCELED);
        TRANSITIONS.put(OrderStatus.PENDING_PAY, pendingPay);

        Map<OrderEvent, OrderStatus> paid = new EnumMap<>(OrderEvent.class);
        paid.put(OrderEvent.SHIP, OrderStatus.SHIPPED);
        TRANSITIONS.put(OrderStatus.PAID, paid);

        Map<OrderEvent, OrderStatus> shipped = new EnumMap<>(OrderEvent.class);
        shipped.put(OrderEvent.FINISH, OrderStatus.FINISHED);
        TRANSITIONS.put(OrderStatus.SHIPPED, shipped);
    }

    private OrderStateMachine()
    {
    }

    public static OrderStatus next(OrderStatus current, OrderEvent event)
    {
        if (current == null || event == null)
        {
            return null;
        }
        Map<OrderEvent, OrderStatus> eventStatusMap = TRANSITIONS.get(current);
        return eventStatusMap == null ? null : eventStatusMap.get(event);
    }
}
