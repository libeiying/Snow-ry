package com.snow.business.order.mapper;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;
import com.snow.business.order.domain.OrderInfo;

/**
 * 订单主表 Mapper
 */
public interface OrderInfoMapper
{
    public OrderInfo selectOrderById(@Param("id") Long id);

    public OrderInfo selectOrderByOrderNo(@Param("orderNo") String orderNo);

    public OrderInfo selectOrderByOrderNoAndUserId(@Param("orderNo") String orderNo, @Param("userId") Long userId);

    public List<OrderInfo> selectOrderList(OrderInfo orderInfo);

    public int insertOrder(OrderInfo orderInfo);

    public int updateOrderStatus(@Param("id") Long id,
                                 @Param("fromStatus") String fromStatus,
                                 @Param("toStatus") String toStatus,
                                 @Param("payStatus") String payStatus);

    public int cancelTimeoutOrders(@Param("timeoutMinutes") int timeoutMinutes, @Param("limit") int limit);

    public Long countAllOrders();

    public Long countTodayOrders();

    public Long countByOrderStatus(@Param("orderStatus") String orderStatus);

    public Long countByPayStatus(@Param("payStatus") String payStatus);

    public BigDecimal sumPayAmountByPayStatus(@Param("payStatus") String payStatus);

    public List<Map<String, Object>> selectDailyOrderTrend(@Param("days") int days);

    public List<Map<String, Object>> selectOrderStatusDistribution();

    public List<Map<String, Object>> selectPayChannelDistribution();
}
