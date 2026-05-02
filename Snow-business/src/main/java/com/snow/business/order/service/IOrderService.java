package com.snow.business.order.service;

import java.util.List;
import java.util.Map;
import com.snow.business.order.domain.OrderInfo;

/**
 * 订单服务
 */
public interface IOrderService
{
    public String submitOrder(Long userId, String receiverName, String receiverPhone, String receiverAddress, String remark);

    public List<OrderInfo> selectOrderListByUserId(Long userId);

    public Map<String, Object> selectOrderDetailByOrderNo(String orderNo, Long userId, boolean checkUser);

    public int handlePayCallback(String orderNo, Long userId, String paidAmount, String payChannel, String transactionNo, String callbackPayload);

    public int cancelOrder(String orderNo, Long userId);

    public int finishOrder(String orderNo, Long userId);

    public int shipOrder(String orderNo);

    public List<OrderInfo> selectManageOrderList(OrderInfo query);

    public int cancelTimeoutOrders(int timeoutMinutes, int limit);

    public Map<String, Object> selectManageOrderStats(int days);
}
