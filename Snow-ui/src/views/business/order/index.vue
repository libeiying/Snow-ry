<template>
  <div class="app-container">
    <el-row :gutter="12" class="mb12">
      <el-col :span="4"><div class="metric-card"><div class="metric-title">订单总数</div><div class="metric-value">{{ overview.totalOrders || 0 }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">待支付</div><div class="metric-value warning">{{ overview.pendingPayOrders || 0 }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">已支付</div><div class="metric-value primary">{{ overview.paidOrders || 0 }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">已完成</div><div class="metric-value success">{{ overview.finishedOrders || 0 }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">支付率</div><div class="metric-value">{{ overview.paidRate || 0 }}%</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">成交金额</div><div class="metric-value">{{ overview.paidAmountTotal || 0 }}</div></div></el-col>
    </el-row>

    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="订单号" prop="orderNo">
        <el-input v-model="queryParams.orderNo" placeholder="请输入订单号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="用户ID" prop="userId">
        <el-input v-model="queryParams.userId" placeholder="请输入用户ID" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="订单状态" prop="orderStatus">
        <el-select v-model="queryParams.orderStatus" placeholder="请选择订单状态" clearable>
          <el-option v-for="item in orderStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付状态" prop="payStatus">
        <el-select v-model="queryParams.payStatus" placeholder="请选择支付状态" clearable>
          <el-option v-for="item in payStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-data-analysis" size="mini" @click="openStats" v-hasPermi="['business:orderStats:list']">统计图表</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['business:order:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="orderList">
      <el-table-column label="订单号" align="center" prop="orderNo" min-width="180" />
      <el-table-column label="用户ID" align="center" prop="userId" width="90" />
      <el-table-column label="订单状态" align="center" width="110">
        <template slot-scope="scope">
          <el-tag size="small" :type="getOrderStatusTagType(scope.row.orderStatus)">
            {{ formatOrderStatus(scope.row.orderStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="支付状态" align="center" width="100">
        <template slot-scope="scope">
          <el-tag size="small" :type="getPayStatusTagType(scope.row.payStatus)">
            {{ formatPayStatus(scope.row.payStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="订单总额(元)" align="center" prop="totalAmount" width="120" />
      <el-table-column label="实付金额(元)" align="center" prop="payAmount" width="120" />
      <el-table-column label="收货人" align="center" prop="receiverName" width="110" />
      <el-table-column label="联系电话" align="center" prop="receiverPhone" width="130" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="220" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)" v-hasPermi="['business:order:query']">详情</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-truck"
            @click="handleShip(scope.row)"
            v-hasPermi="['business:order:ship']"
            v-if="scope.row.orderStatus === '1'"
          >发货</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listOrder, shipOrder } from "@/api/business/order"
import { getOrderStats } from "@/api/business/orderStats"

export default {
  name: "Order",
  data() {
    return {
      loading: false,
      showSearch: true,
      total: 0,
      orderList: [],
      overview: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        orderNo: undefined,
        userId: undefined,
        orderStatus: undefined,
        payStatus: undefined
      },
      orderStatusOptions: [
        { label: "待支付", value: "0" },
        { label: "已支付", value: "1" },
        { label: "已取消", value: "2" },
        { label: "已发货", value: "3" },
        { label: "已完成", value: "4" }
      ],
      payStatusOptions: [
        { label: "未支付", value: "0" },
        { label: "已支付", value: "1" }
      ]
    }
  },
  created() {
    this.getList()
    this.loadOverview()
  },
  methods: {
    loadOverview() {
      getOrderStats({ days: 7 }).then(response => {
        this.overview = (response.data && response.data.overview) || {}
      })
    },
    getList() {
      this.loading = true
      listOrder(this.queryParams).then(response => {
        this.orderList = response.rows || []
        this.total = response.total || 0
      }).finally(() => {
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleDetail(row) {
      this.$tab.openPage("订单详情", "/business/order-detail/index/" + row.orderNo)
    },
    openStats() {
      if (this.$tab && this.$tab.openPage) {
        this.$tab.openPage("订单统计", "/statistics/orderStats")
        return
      }
      this.$router.push("/statistics/orderStats")
    },
    handleShip(row) {
      this.$modal.confirm("确认将订单【" + row.orderNo + "】标记为已发货吗？").then(() => {
        return shipOrder(row.orderNo)
      }).then(() => {
        this.$modal.msgSuccess("发货成功")
        this.getList()
        this.loadOverview()
      }).catch(() => {})
    },
    handleExport() {
      this.download('/business/order/export', {
        ...this.queryParams
      }, `order_${new Date().getTime()}.xlsx`)
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
    formatPayStatus(status) {
      return status === "1" ? "已支付" : "未支付"
    },
    getPayStatusTagType(status) {
      return status === "1" ? "success" : "danger"
    }
  }
}
</script>

<style scoped>
.mb12 {
  margin-bottom: 12px;
}

.metric-card {
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ebeef5;
  padding: 10px 12px;
}

.metric-title {
  font-size: 12px;
  color: #909399;
  margin-bottom: 6px;
}

.metric-value {
  font-size: 20px;
  color: #303133;
  font-weight: 600;
}

.metric-value.warning {
  color: #e6a23c;
}

.metric-value.primary {
  color: #409eff;
}

.metric-value.success {
  color: #67c23a;
}
</style>
