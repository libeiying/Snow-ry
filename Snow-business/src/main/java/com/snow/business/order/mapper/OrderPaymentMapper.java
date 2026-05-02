package com.snow.business.order.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.snow.business.order.domain.OrderPayment;

/**
 * 支付流水 Mapper
 */
public interface OrderPaymentMapper
{
    public OrderPayment selectLatestByOrderNo(@Param("orderNo") String orderNo);

    public List<OrderPayment> selectPaymentListByOrderNo(@Param("orderNo") String orderNo);

    public int insertOrderPayment(OrderPayment payment);

    public int markPaymentSuccess(@Param("id") Long id,
                                  @Param("payChannel") String payChannel,
                                  @Param("transactionNo") String transactionNo,
                                  @Param("callbackPayload") String callbackPayload);
}
