package com.snow.web.controller.business;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.snow.business.order.domain.OrderInfo;
import com.snow.business.order.service.IOrderService;
import com.snow.common.annotation.Log;
import com.snow.common.core.controller.BaseController;
import com.snow.common.core.domain.AjaxResult;
import com.snow.common.core.page.TableDataInfo;
import com.snow.common.enums.BusinessType;
import com.snow.common.utils.poi.ExcelUtil;

/**
 * 管理端订单接口
 */
@RestController
@RequestMapping("/business/order")
public class OrderManageController extends BaseController
{
    @Autowired
    private IOrderService orderService;

    @PreAuthorize("@ss.hasPermi('business:order:list')")
    @GetMapping("/list")
    public TableDataInfo list(OrderInfo query)
    {
        startPage();
        List<OrderInfo> list = orderService.selectManageOrderList(query);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:order:export')")
    @Log(title = "订单管理", businessType = BusinessType.EXPORT)
    @GetMapping("/export")
    public void export(HttpServletResponse response, OrderInfo query)
    {
        List<OrderInfo> list = orderService.selectManageOrderList(query);
        ExcelUtil<OrderInfo> util = new ExcelUtil<OrderInfo>(OrderInfo.class);
        util.exportExcel(response, list, "订单数据");
    }

    @PreAuthorize("@ss.hasPermi('business:order:query')")
    @GetMapping("/{orderNo}")
    public AjaxResult detail(@PathVariable("orderNo") String orderNo)
    {
        Map<String, Object> data = orderService.selectOrderDetailByOrderNo(orderNo, null, false);
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('business:orderStats:list')")
    @GetMapping("/stats")
    public AjaxResult stats(Integer days)
    {
        Map<String, Object> data = orderService.selectManageOrderStats(days == null ? 7 : days.intValue());
        return success(data);
    }

    @PreAuthorize("@ss.hasPermi('business:order:ship')")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{orderNo}/ship")
    public AjaxResult ship(@PathVariable("orderNo") String orderNo)
    {
        return toAjax(orderService.shipOrder(orderNo));
    }
}
