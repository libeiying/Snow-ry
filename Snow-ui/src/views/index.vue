<template>
  <div class="snow-home app-container">
    <el-card shadow="never" class="hero-card">
      <div class="hero-mask"></div>
      <div class="hero-content">
        <div>
          <h2>雪程搭子 · 运营总览</h2>
          <p>围绕订单、统计、监控、日志的一体化运营中台</p>
        </div>
        <el-button type="success" size="mini" @click="openPage({ name: '订单统计', path: '/statistics/orderStats' })">查看今日看板</el-button>
      </div>
      <el-row :gutter="10" class="kpi-row">
        <el-col :xs="12" :sm="8" :md="6" :lg="3" v-for="item in kpis" :key="item.label">
          <div class="kpi-card">
            <div class="kpi-value">{{ item.value }}</div>
            <div class="kpi-label">{{ item.label }}</div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <el-row :gutter="16">
      <el-col :xs="24" :md="16">
        <el-card class="section-card" shadow="hover">
          <div slot="header"><span>业务入口</span></div>
          <el-row :gutter="10">
            <el-col :xs="24" :sm="12" v-for="entry in entries" :key="entry.path">
              <div class="entry-item" @click="openPage(entry)">
                <div class="entry-title-wrap">
                  <span class="entry-name">{{ entry.name }}</span>
                  <el-tag size="mini" :type="entry.tagType">{{ entry.tag }}</el-tag>
                </div>
                <div class="entry-desc">{{ entry.desc }}</div>
              </div>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="8">
        <el-card class="section-card" shadow="hover">
          <div slot="header"><span>运营提醒</span></div>
          <ul class="todo-list">
            <li v-for="todo in todos" :key="todo">{{ todo }}</li>
          </ul>
        </el-card>
        <el-card class="section-card mini-card" shadow="hover">
          <div slot="header"><span>系统运行入口</span></div>
          <div class="quick-row">
            <el-button size="mini" @click="openPage({ name: '在线用户', path: '/monitor/online' })">在线用户</el-button>
            <el-button size="mini" @click="openPage({ name: '缓存监控', path: '/monitor/cache' })">缓存监控</el-button>
            <el-button size="mini" @click="openPage({ name: '日志管理', path: '/monitor/operlog' })">日志管理</el-button>
            <el-button size="mini" @click="openPage({ name: '定时任务', path: '/monitor/job' })">定时任务</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
      kpis: [
        { label: "旅游团", value: "在线" },
        { label: "文创商品", value: "在线" },
        { label: "景点资源", value: "在线" },
        { label: "路线模板", value: "在线" },
        { label: "订单管理", value: "在线" },
        { label: "订单统计", value: "在线" },
        { label: "系统监控", value: "在线" },
        { label: "日志管理", value: "在线" }
      ],
      entries: [
        { name: "旅游团管理", path: "/travel/tourGroup", desc: "维护团期、线路与价格策略", tag: "业务", tagType: "success" },
        { name: "文创商品管理", path: "/goods/culturalCreative", desc: "商品上新、库存与销售跟踪", tag: "业务", tagType: "success" },
        { name: "东北景点管理", path: "/scenic/northeastAttraction", desc: "景点主数据、标签与门票信息", tag: "业务", tagType: "success" },
        { name: "景点关系管理", path: "/scenic/northeastAttractionRelation", desc: "景点关系网络和推荐路径", tag: "业务", tagType: "success" },
        { name: "路线模板管理", path: "/scenic/northeastRouteTemplate", desc: "模板配置与预算建议管理", tag: "配置", tagType: "warning" },
        { name: "订单管理", path: "/business/order", desc: "订单查询、发货与导出", tag: "订单", tagType: "primary" },
        { name: "订单统计", path: "/statistics/orderStats", desc: "趋势、状态、渠道统计分析", tag: "看板", tagType: "primary" },
        { name: "日志管理", path: "/monitor/operlog", desc: "操作日志审计与故障排查", tag: "监控", tagType: "info" }
      ],
      todos: [
        "补充东北景点图片与交通建议字段数据",
        "完善路线模板的每日安排 JSON 结构规范",
        "梳理关系类型字典，统一 same_city / nearby 等枚举",
        "按季度复核景点门票与开放时间数据",
        "定期巡检订单支付回调与超时关单任务",
        "每周复盘订单统计图表波动并校验渠道数据"
      ]
    }
  },
  methods: {
    openPage(entry) {
      if (this.$tab && this.$tab.openPage) {
        this.$tab.openPage(entry.name, entry.path)
        return
      }
      this.$router.push(entry.path)
    }
  }
}
</script>

<style scoped lang="scss">
.snow-home {
  .hero-card {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    margin-bottom: 16px;
    background: linear-gradient(135deg, #153352 0%, #214a73 45%, #326493 100%);
    color: #fff;
  }

  .hero-mask {
    position: absolute;
    right: -80px;
    top: -80px;
    width: 260px;
    height: 260px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.08);
  }

  .hero-content {
    position: relative;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 14px;
  }

  h2 {
    margin: 0 0 8px 0;
    font-size: 24px;
    color: #fff;
  }

  p {
    margin: 0;
    color: rgba(255, 255, 255, 0.88);
  }

  .kpi-row {
    margin-top: 8px;
  }

  .kpi-card {
    background: rgba(255, 255, 255, 0.08);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 8px;
    padding: 12px 10px;
    margin-bottom: 12px;
    text-align: center;
    backdrop-filter: blur(2px);
  }

  .kpi-value {
    font-size: 17px;
    color: #fff;
    font-weight: 600;
    line-height: 1.2;
  }

  .kpi-label {
    margin-top: 6px;
    color: rgba(255, 255, 255, 0.8);
    font-size: 12px;
  }

  .section-card {
    border-radius: 10px;
    margin-bottom: 16px;
  }

  .mini-card {
    margin-top: 0;
  }

  .entry-item {
    border: 1px solid #ebeef5;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .entry-item:hover {
    border-color: #2f93f6;
    background: #f2f8ff;
    transform: translateY(-1px);
  }

  .entry-title-wrap {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
  }

  .entry-name {
    font-weight: 600;
    color: #303133;
  }

  .entry-desc {
    font-size: 12px;
    color: #909399;
    line-height: 1.5;
  }

  .todo-list {
    margin: 0;
    padding-left: 18px;
    color: #606266;
    line-height: 1.8;
  }

  .quick-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
  }
}
</style>
