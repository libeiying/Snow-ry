package com.snow.business.order.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.snow.business.cart.domain.ShoppingCart;
import com.snow.business.cart.mapper.ShoppingCartMapper;
import com.snow.business.order.domain.OrderInfo;
import com.snow.business.order.domain.OrderItem;
import com.snow.business.order.domain.OrderPayment;
import com.snow.business.order.enums.OrderEvent;
import com.snow.business.order.enums.OrderStateMachine;
import com.snow.business.order.enums.OrderStatus;
import com.snow.business.order.mapper.OrderInfoMapper;
import com.snow.business.order.mapper.OrderItemMapper;
import com.snow.business.order.mapper.OrderPaymentMapper;
import com.snow.business.order.service.IOrderService;
import com.snow.common.exception.ServiceException;
import com.snow.common.utils.DateUtils;

/**
 * 订单服务实现
 */
@Service
public class OrderServiceImpl implements IOrderService
{
    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private OrderPaymentMapper orderPaymentMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String submitOrder(Long userId, String receiverName, String receiverPhone, String receiverAddress, String remark)
    {
        if (isBlank(receiverName) || isBlank(receiverPhone) || isBlank(receiverAddress))
        {
            throw new ServiceException("收货信息不能为空");
        }

        List<ShoppingCart> checkedList = shoppingCartMapper.selectCheckedListForUpdate(userId);
        if (checkedList == null || checkedList.isEmpty())
        {
            throw new ServiceException("请选择需要结算的商品");
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        List<OrderItem> itemList = new ArrayList<>();
        String orderNo = generateOrderNo(userId);
        for (ShoppingCart cart : checkedList)
        {
            BigDecimal itemAmount = cart.getUnitPrice().multiply(BigDecimal.valueOf(cart.getQuantity()));
            totalAmount = totalAmount.add(itemAmount);

            OrderItem item = new OrderItem();
            item.setOrderNo(orderNo);
            item.setUserId(userId);
            item.setProductId(cart.getProductId());
            item.setProductCode(cart.getProductCode());
            item.setProductTitle(cart.getProductTitle());
            item.setProductImage(cart.getProductImage());
            item.setSkuText(cart.getSkuText());
            item.setUnitPrice(cart.getUnitPrice());
            item.setQuantity(cart.getQuantity());
            itemList.add(item);
        }

        OrderInfo order = new OrderInfo();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setOrderStatus(OrderStatus.PENDING_PAY.getCode());
        order.setPayStatus("0");
        order.setTotalAmount(totalAmount);
        order.setPayAmount(totalAmount);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setRemark(remark);
        orderInfoMapper.insertOrder(order);

        for (OrderItem item : itemList)
        {
            item.setOrderId(order.getId());
        }
        orderItemMapper.insertOrderItems(itemList);
        shoppingCartMapper.markCheckedAsOrdered(userId);
        return orderNo;
    }

    @Override
    public List<OrderInfo> selectOrderListByUserId(Long userId)
    {
        OrderInfo query = new OrderInfo();
        query.setUserId(userId);
        return orderInfoMapper.selectOrderList(query);
    }

    @Override
    public Map<String, Object> selectOrderDetailByOrderNo(String orderNo, Long userId, boolean checkUser)
    {
        OrderInfo order = checkUser ? orderInfoMapper.selectOrderByOrderNoAndUserId(orderNo, userId) : orderInfoMapper.selectOrderByOrderNo(orderNo);
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        Map<String, Object> data = new HashMap<>();
        data.put("order", order);
        data.put("items", orderItemMapper.selectOrderItemListByOrderNo(orderNo));
        data.put("payment", orderPaymentMapper.selectLatestByOrderNo(orderNo));
        data.put("paymentList", orderPaymentMapper.selectPaymentListByOrderNo(orderNo));
        return data;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int handlePayCallback(String orderNo, Long userId, String paidAmount, String payChannel, String transactionNo, String callbackPayload)
    {
        OrderInfo order = userId == null ? orderInfoMapper.selectOrderByOrderNo(orderNo) : orderInfoMapper.selectOrderByOrderNoAndUserId(orderNo, userId);
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }

        String finalChannel = isBlank(payChannel) ? "MOCK" : payChannel.trim().toUpperCase();
        String finalTxnNo = isBlank(transactionNo) ? generateTxnNo(orderNo) : transactionNo.trim();
        String finalPayload = isBlank(callbackPayload) ? "{}" : callbackPayload;

        // 支付回调幂等：已支付直接返回成功，避免重复通知导致报错。
        if (OrderStatus.PAID.getCode().equals(order.getOrderStatus()) && "1".equals(order.getPayStatus()))
        {
            upsertPaymentSuccess(order, finalChannel, finalTxnNo, finalPayload);
            return 1;
        }

        if (!isBlank(paidAmount))
        {
            BigDecimal callbackAmount = new BigDecimal(paidAmount);
            if (order.getPayAmount() != null && order.getPayAmount().compareTo(callbackAmount) != 0)
            {
                throw new ServiceException("支付金额与订单金额不一致");
            }
        }
        upsertPaymentSuccess(order, finalChannel, finalTxnNo, finalPayload);
        return doTransfer(order, OrderEvent.PAY);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cancelOrder(String orderNo, Long userId)
    {
        OrderInfo order = orderInfoMapper.selectOrderByOrderNoAndUserId(orderNo, userId);
        return doTransfer(order, OrderEvent.CANCEL);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int finishOrder(String orderNo, Long userId)
    {
        OrderInfo order = orderInfoMapper.selectOrderByOrderNoAndUserId(orderNo, userId);
        return doTransfer(order, OrderEvent.FINISH);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int shipOrder(String orderNo)
    {
        OrderInfo order = orderInfoMapper.selectOrderByOrderNo(orderNo);
        return doTransfer(order, OrderEvent.SHIP);
    }

    @Override
    public List<OrderInfo> selectManageOrderList(OrderInfo query)
    {
        return orderInfoMapper.selectOrderList(query);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cancelTimeoutOrders(int timeoutMinutes, int limit)
    {
        int realTimeoutMinutes = timeoutMinutes <= 0 ? 15 : timeoutMinutes;
        int realLimit = limit <= 0 ? 200 : limit;
        return orderInfoMapper.cancelTimeoutOrders(realTimeoutMinutes, realLimit);
    }

    @Override
    public Map<String, Object> selectManageOrderStats(int days)
    {
        int realDays = days <= 0 ? 7 : Math.min(days, 60);
        Map<String, Object> overview = new HashMap<>();
        overview.put("totalOrders", orderInfoMapper.countAllOrders());
        overview.put("todayOrders", orderInfoMapper.countTodayOrders());
        overview.put("pendingPayOrders", orderInfoMapper.countByOrderStatus("0"));
        overview.put("paidOrders", orderInfoMapper.countByOrderStatus("1"));
        overview.put("shippedOrders", orderInfoMapper.countByOrderStatus("3"));
        overview.put("finishedOrders", orderInfoMapper.countByOrderStatus("4"));
        overview.put("cancelOrders", orderInfoMapper.countByOrderStatus("2"));
        overview.put("paidAmountTotal", orderInfoMapper.sumPayAmountByPayStatus("1"));
        overview.put("paidRate", calculateRate(orderInfoMapper.countByPayStatus("1"), orderInfoMapper.countAllOrders()));

        Map<String, Object> data = new HashMap<>();
        data.put("overview", overview);
        data.put("trend", orderInfoMapper.selectDailyOrderTrend(realDays));
        data.put("statusDistribution", orderInfoMapper.selectOrderStatusDistribution());
        data.put("channelDistribution", orderInfoMapper.selectPayChannelDistribution());
        return data;
    }

    private int doTransfer(OrderInfo order, OrderEvent event)
    {
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        OrderStatus current = OrderStatus.fromCode(order.getOrderStatus());
        OrderStatus next = OrderStateMachine.next(current, event);
        if (next == null)
        {
            throw new ServiceException("当前状态不允许执行该操作");
        }

        String payStatus = null;
        if (event == OrderEvent.PAY)
        {
            payStatus = "1";
        }

        int rows = orderInfoMapper.updateOrderStatus(order.getId(), current.getCode(), next.getCode(), payStatus);
        if (rows == 0)
        {
            throw new ServiceException("订单状态已变更，请刷新后重试");
        }
        return rows;
    }

    private String generateOrderNo(Long userId)
    {
        String userPart = String.valueOf(userId % 100000);
        return DateUtils.dateTimeNow("yyyyMMddHHmmssSSS") + String.format("%05d", Integer.parseInt(userPart));
    }

    private boolean isBlank(String text)
    {
        return text == null || text.trim().isEmpty();
    }

    private void upsertPaymentSuccess(OrderInfo order, String payChannel, String transactionNo, String callbackPayload)
    {
        OrderPayment payment = orderPaymentMapper.selectLatestByOrderNo(order.getOrderNo());
        if (payment == null)
        {
            payment = new OrderPayment();
            payment.setPaymentNo(generatePaymentNo(order.getOrderNo()));
            payment.setOrderNo(order.getOrderNo());
            payment.setUserId(order.getUserId());
            payment.setAmount(order.getPayAmount());
            payment.setPayChannel(payChannel);
            payment.setPayStatus("1");
            payment.setTransactionNo(transactionNo);
            payment.setCallbackPayload(callbackPayload);
            payment.setFailReason(null);
            orderPaymentMapper.insertOrderPayment(payment);
            return;
        }
        if ("1".equals(payment.getPayStatus()))
        {
            return;
        }
        orderPaymentMapper.markPaymentSuccess(payment.getId(), payChannel, transactionNo, callbackPayload);
    }

    private String generatePaymentNo(String orderNo)
    {
        return "PAY" + DateUtils.dateTimeNow("yyyyMMddHHmmssSSS") + orderNo.substring(Math.max(0, orderNo.length() - 6));
    }

    private String generateTxnNo(String orderNo)
    {
        return "TXN" + DateUtils.dateTimeNow("yyyyMMddHHmmssSSS") + orderNo.substring(Math.max(0, orderNo.length() - 6));
    }

    private BigDecimal calculateRate(Long numerator, Long denominator)
    {
        long up = numerator == null ? 0L : numerator;
        long down = denominator == null ? 0L : denominator;
        if (down <= 0L)
        {
            return BigDecimal.ZERO;
        }
        return BigDecimal.valueOf(up)
            .multiply(BigDecimal.valueOf(100))
            .divide(BigDecimal.valueOf(down), 2, RoundingMode.HALF_UP);
    }
}
