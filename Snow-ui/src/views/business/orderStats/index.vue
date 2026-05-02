<template>
  <div class="app-container order-stats-container" v-loading="loading">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" label-width="88px" class="mb12">
      <el-form-item label="统计周期" prop="days">
        <el-select v-model="queryParams.days" style="width: 140px">
          <el-option label="近7天" :value="7" />
          <el-option label="近15天" :value="15" />
          <el-option label="近30天" :value="30" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="loadData">刷新</el-button>
      </el-form-item>
      <el-form-item>
        <span class="last-update-time">最近刷新：{{ lastUpdateTime || "-" }}</span>
      </el-form-item>
    </el-form>

    <el-row :gutter="12" class="mb12">
      <el-col :span="4"><div class="metric-card"><div class="metric-title">订单总数</div><div class="metric-value">{{ formatNumber(overview.totalOrders) }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">今日订单</div><div class="metric-value">{{ formatNumber(overview.todayOrders) }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">待支付</div><div class="metric-value warning">{{ formatNumber(overview.pendingPayOrders) }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">已支付</div><div class="metric-value primary">{{ formatNumber(overview.paidOrders) }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">已完成</div><div class="metric-value success">{{ formatNumber(overview.finishedOrders) }}</div></div></el-col>
      <el-col :span="4"><div class="metric-card"><div class="metric-title">支付率</div><div class="metric-value">{{ formatPercent(overview.paidRate) }}</div></div></el-col>
    </el-row>

    <el-row :gutter="12">
      <el-col :span="24">
        <el-card shadow="never" class="mb12">
          <div slot="header"><span>订单趋势（单量 / 成交额）</span></div>
          <div ref="trendChart" class="chart-box"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="never">
          <div slot="header"><span>订单状态分布</span></div>
          <div ref="statusChart" class="chart-box"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="never">
          <div slot="header"><span>支付渠道分布</span></div>
          <div ref="channelChart" class="chart-box"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from "echarts"
import { getOrderStats } from "@/api/business/orderStats"

export default {
  name: "OrderStats",
  data() {
    return {
      loading: false,
      lastUpdateTime: "",
      queryParams: {
        days: 7
      },
      overview: {},
      trend: [],
      statusDistribution: [],
      channelDistribution: [],
      trendChart: null,
      statusChart: null,
      channelChart: null
    }
  },
  created() {
    this.loadData()
  },
  mounted() {
    window.addEventListener("resize", this.resizeCharts)
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.resizeCharts)
    this.disposeCharts()
  },
  methods: {
    loadData() {
      this.loading = true
      getOrderStats(this.queryParams).then(response => {
        const data = response.data || {}
        this.overview = data.overview || {}
        this.trend = data.trend || []
        this.statusDistribution = data.statusDistribution || []
        this.channelDistribution = data.channelDistribution || []
        this.lastUpdateTime = this.parseTime(new Date(), "{y}-{m}-{d} {h}:{i}:{s}")
        this.$nextTick(() => {
          this.renderTrendChart()
          this.renderStatusChart()
          this.renderChannelChart()
        })
      }).finally(() => {
        this.loading = false
      })
    },
    renderTrendChart() {
      if (!this.trendChart) {
        this.trendChart = echarts.init(this.$refs.trendChart, "macarons")
      }
      this.trendChart.setOption({
        tooltip: { trigger: "axis" },
        legend: { data: ["订单数", "支付金额"] },
        grid: { left: "4%", right: "4%", bottom: "4%", containLabel: true },
        xAxis: { type: "category", data: this.trend.map(item => item.dayLabel) },
        yAxis: [
          { type: "value", name: "订单数" },
          { type: "value", name: "金额(元)" }
        ],
        series: [
          { name: "订单数", type: "bar", data: this.trend.map(item => item.orderCount), itemStyle: { color: "#409EFF" } },
          { name: "支付金额", type: "line", yAxisIndex: 1, smooth: true, data: this.trend.map(item => item.paidAmount), itemStyle: { color: "#67C23A" } }
        ]
      })
    },
    renderStatusChart() {
      if (!this.statusChart) {
        this.statusChart = echarts.init(this.$refs.statusChart, "macarons")
      }
      this.statusChart.setOption({
        tooltip: { trigger: "item" },
        legend: { bottom: 0 },
        series: [{
          type: "pie",
          radius: ["35%", "65%"],
          label: {
            formatter: "{b}\n{d}%"
          },
          data: this.statusDistribution.map(item => ({
            name: this.formatOrderStatus(item.status),
            value: item.total
          }))
        }]
      })
    },
    renderChannelChart() {
      if (!this.channelChart) {
        this.channelChart = echarts.init(this.$refs.channelChart, "macarons")
      }
      this.channelChart.setOption({
        tooltip: { trigger: "axis", axisPointer: { type: "shadow" } },
        grid: { left: "4%", right: "4%", bottom: "4%", containLabel: true },
        xAxis: { type: "category", data: this.channelDistribution.map(item => item.channel || "未知") },
        yAxis: { type: "value", name: "笔数" },
        series: [{
          type: "bar",
          barWidth: "40%",
          data: this.channelDistribution.map(item => item.total),
          itemStyle: { color: "#E6A23C" }
        }]
      })
    },
    resizeCharts() {
      this.trendChart && this.trendChart.resize()
      this.statusChart && this.statusChart.resize()
      this.channelChart && this.channelChart.resize()
    },
    disposeCharts() {
      this.trendChart && this.trendChart.dispose()
      this.statusChart && this.statusChart.dispose()
      this.channelChart && this.channelChart.dispose()
      this.trendChart = null
      this.statusChart = null
      this.channelChart = null
    },
    formatOrderStatus(status) {
      const map = {
        "0": "待支付",
        "1": "已支付",
        "2": "已取消",
        "3": "已发货",
        "4": "已完成"
      }
      return map[String(status)] || "未知"
    },
    formatNumber(value) {
      if (value === undefined || value === null) {
        return "0"
      }
      return String(value)
    },
    formatPercent(value) {
      if (value === undefined || value === null) {
        return "0%"
      }
      return value + "%"
    }
  }
}
</script>

<style scoped>
.order-stats-container {
  background: #f5f7fa;
}

.mb12 {
  margin-bottom: 12px;
}

.last-update-time {
  color: #909399;
  font-size: 12px;
}

.metric-card {
  background: #fff;
  border-radius: 8px;
  padding: 12px 14px;
  min-height: 78px;
}

.metric-title {
  color: #909399;
  font-size: 13px;
  margin-bottom: 8px;
}

.metric-value {
  color: #303133;
  font-size: 22px;
  font-weight: 600;
}

.metric-value.success {
  color: #67c23a;
}

.metric-value.primary {
  color: #409eff;
}

.metric-value.warning {
  color: #e6a23c;
}

.chart-box {
  height: 360px;
}
</style>
