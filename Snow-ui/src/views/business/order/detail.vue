<template>
  <div class="app-container">
    <el-card v-loading="loading" shadow="never">
      <div slot="header" class="clearfix">
        <span>订单详情</span>
        <div style="float: right">
          <el-button size="mini" @click="goBack">返 回</el-button>
        </div>
      </div>

      <el-divider content-position="left">订单信息</el-divider>
      <el-descriptions :column="3" border size="small">
        <el-descriptions-item label="订单号">{{ order.orderNo || "-" }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ order.userId || "-" }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag size="small" :type="getOrderStatusTagType(order.orderStatus)">{{ formatOrderStatus(order.orderStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="支付状态">
          <el-tag size="small" :type="order.payStatus === '1' ? 'success' : 'danger'">{{ order.payStatus === "1" ? "已支付" : "未支付" }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="订单总额(元)">{{ order.totalAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="实付金额(元)">{{ order.payAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="收货人">{{ order.receiverName || "-" }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ order.receiverPhone || "-" }}</el-descriptions-item>
        <el-descriptions-item label="收货地址" :span="3">{{ order.receiverAddress || "-" }}</el-descriptions-item>
        <el-descriptions-item label="下单时间">{{ order.createTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ order.payTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="取消时间">{{ order.cancelTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="发货时间">{{ order.shipTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="完成时间">{{ order.finishTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ order.updateTime || "-" }}</el-descriptions-item>
        <el-descriptions-item label="订单备注" :span="3">{{ order.remark || "-" }}</el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">订单明细</el-divider>
      <el-table :data="items" border size="small">
        <el-table-column label="商品ID" align="center" prop="productId" width="100" />
        <el-table-column label="商品编码" align="center" prop="productCode" width="150" />
        <el-table-column label="商品标题" align="center" prop="productTitle" min-width="180" :show-overflow-tooltip="true" />
        <el-table-column label="规格" align="center" prop="skuText" min-width="140" :show-overflow-tooltip="true" />
        <el-table-column label="单价(元)" align="center" prop="unitPrice" width="100" />
        <el-table-column label="数量" align="center" prop="quantity" width="70" />
        <el-table-column label="小计(元)" align="center" prop="itemAmount" width="100" />
      </el-table>

      <el-divider content-position="left">支付流水</el-divider>
      <el-table :data="paymentList" border size="small">
        <el-table-column label="支付单号" align="center" prop="paymentNo" min-width="180" />
        <el-table-column label="渠道" align="center" prop="payChannel" width="90" />
        <el-table-column label="状态" align="center" width="90">
          <template slot-scope="scope">
            <el-tag size="small" :type="getPaymentStatusTagType(scope.row.payStatus)">
              {{ formatPaymentStatus(scope.row.payStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="金额(元)" align="center" prop="amount" width="100" />
        <el-table-column label="交易号" align="center" prop="transactionNo" min-width="170" :show-overflow-tooltip="true" />
        <el-table-column label="支付时间" align="center" prop="paidTime" width="160" />
        <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getOrderDetail } from "@/api/business/order"

export default {
  name: "OrderDetail",
  data() {
    return {
      loading: false,
      order: {},
      items: [],
      paymentList: []
    }
  },
  created() {
    this.loadDetail()
  },
  methods: {
    loadDetail() {
      const orderNo = this.$route.params.orderNo
      if (!orderNo) {
        this.$modal.msgError("缺少订单号")
        return
      }
      this.loading = true
      getOrderDetail(orderNo).then(response => {
        const data = response.data || {}
        this.order = data.order || {}
        this.items = data.items || []
        this.paymentList = data.paymentList || []
      }).finally(() => {
        this.loading = false
      })
    },
    goBack() {
      this.$router.push("/business/order")
    },
    formatOrderStatus(status) {
      const map = {
        "0": "待支付",
        "1": "已支付",
        "2": "已取消",
        "3": "已发货",
        "4": "已完成"
      }
      return map[status] || "未知"
    },
    getOrderStatusTagType(status) {
      const map = {
        "0": "warning",
        "1": "primary",
        "2": "danger",
        "3": "info",
        "4": "success"
      }
      return map[status] || "info"
    },
    formatPaymentStatus(status) {
      const map = {
        "0": "待支付",
        "1": "成功",
        "2": "失败"
      }
      return map[status] || "未知"
    },
    getPaymentStatusTagType(status) {
      const map = {
        "0": "warning",
        "1": "success",
        "2": "danger"
      }
      return map[status] || "info"
    }
  }
}
</script>
