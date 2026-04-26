package com.snow.web.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.snow.business.order.service.IOrderService;

/**
 * 订单定时任务
 */
@Component("orderTask")
public class OrderTask
{
    private static final Logger log = LoggerFactory.getLogger(OrderTask.class);

    @Autowired
    private IOrderService orderService;

    /**
     * 默认规则：15分钟未支付自动取消，每次最多处理200单。
     * invoke_target: orderTask.cancelTimeoutOrders()
     */
    public void cancelTimeoutOrders()
    {
        int rows = orderService.cancelTimeoutOrders(15, 200);
        log.info("orderTask.cancelTimeoutOrders executed, canceled rows={}", rows);
    }

    /**
     * 可配置参数版本。
     * invoke_target: orderTask.cancelTimeoutOrdersWithParams('15','500')
     */
    public void cancelTimeoutOrdersWithParams(String timeoutMinutes, String limit)
    {
        int timeout = parseIntOrDefault(timeoutMinutes, 15);
        int batchLimit = parseIntOrDefault(limit, 200);
        int rows = orderService.cancelTimeoutOrders(timeout, batchLimit);
        log.info("orderTask.cancelTimeoutOrdersWithParams executed, timeoutMinutes={}, limit={}, canceled rows={}", timeout, batchLimit, rows);
    }

    private int parseIntOrDefault(String text, int defaultValue)
    {
        try
        {
            return Integer.parseInt(text);
        }
        catch (Exception e)
        {
            return defaultValue;
        }
    }
}
