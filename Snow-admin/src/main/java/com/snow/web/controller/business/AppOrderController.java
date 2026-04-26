package com.snow.web.controller.business;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.business.order.domain.OrderInfo;
import com.snow.business.order.service.IOrderService;
import com.snow.common.annotation.Anonymous;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.exception.ServiceException;

/**
 * 用户端订单接口
 */
@RestController
@RequestMapping("/app/order")
public class AppOrderController extends BaseController
{
    @Autowired
    private IOrderService orderService;

    @GetMapping("/list")
    public AjaxResult list()
    {
        List<OrderInfo> list = orderService.selectOrderListByUserId(getUserId());
        return success(list);
    }

    @GetMapping("/{orderNo}")
    public AjaxResult detail(@PathVariable("orderNo") String orderNo)
    {
        Map<String, Object> data = orderService.selectOrderDetailByOrderNo(orderNo, getUserId(), true);
        return success(data);
    }

    @PostMapping("/submit")
    public AjaxResult submit(@RequestBody SubmitOrderReq req)
    {
        if (req == null)
        {
            throw new ServiceException("请求参数不能为空");
        }
        String orderNo = orderService.submitOrder(getUserId(), req.getReceiverName(), req.getReceiverPhone(), req.getReceiverAddress(), req.getRemark());
        AjaxResult ajax = success();
        ajax.put("orderNo", orderNo);
        return ajax;
    }

    @PutMapping("/{orderNo}/cancel")
    public AjaxResult cancel(@PathVariable("orderNo") String orderNo)
    {
        return toAjax(orderService.cancelOrder(orderNo, getUserId()));
    }

    @PutMapping("/{orderNo}/finish")
    public AjaxResult finish(@PathVariable("orderNo") String orderNo)
    {
        return toAjax(orderService.finishOrder(orderNo, getUserId()));
    }

    /**
     * 支付平台回调（示例：回调成功后驱动订单进入已支付）
     */
    @Anonymous
    @PostMapping("/pay/callback")
    public AjaxResult payCallback(@RequestBody PayCallbackReq req)
    {
        if (req == null || req.getOrderNo() == null || req.getOrderNo().trim().isEmpty())
        {
            throw new ServiceException("orderNo不能为空");
        }
        return toAjax(orderService.handlePayCallback(
            req.getOrderNo().trim(),
            null,
            req.getPaidAmount(),
            req.getPayChannel(),
            req.getTransactionNo(),
            req.getCallbackPayload()));
    }

    public static class SubmitOrderReq
    {
        private String receiverName;
        private String receiverPhone;
        private String receiverAddress;
        private String remark;

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
    }

    public static class PayCallbackReq
    {
        private String orderNo;
        private String paidAmount;
        private String payChannel;
        private String transactionNo;
        private String callbackPayload;

        public String getOrderNo()
        {
            return orderNo;
        }

        public void setOrderNo(String orderNo)
        {
            this.orderNo = orderNo;
        }

        public String getPaidAmount()
        {
            return paidAmount;
        }

        public void setPaidAmount(String paidAmount)
        {
            this.paidAmount = paidAmount;
        }

        public String getPayChannel()
        {
            return payChannel;
        }

        public void setPayChannel(String payChannel)
        {
            this.payChannel = payChannel;
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
    }
}
