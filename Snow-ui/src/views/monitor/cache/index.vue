<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-refresh" size="mini" @click="getList">刷新监控</el-button>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="24" class="card-box">
        <el-card>
          <div slot="header"><span><i class="el-icon-monitor"></i> 基本信息</span></div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <table cellspacing="0" style="width: 100%">
              <tbody>
                <tr>
                  <td class="el-table__cell is-leaf"><div class="cell">Redis版本</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.redis_version }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">运行模式</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.redis_mode == "standalone" ? "单机" : "集群" }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">端口</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.tcp_port }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">客户端数</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.connected_clients }}</div></td>
                </tr>
                <tr>
                  <td class="el-table__cell is-leaf"><div class="cell">运行时间(天)</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.uptime_in_days }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">使用内存</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.used_memory_human }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">使用CPU</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ parseFloat(cache.info.used_cpu_user_children).toFixed(2) }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">内存配置</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.maxmemory_human }}</div></td>
                </tr>
                <tr>
                  <td class="el-table__cell is-leaf"><div class="cell">AOF是否开启</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.aof_enabled == "0" ? "否" : "是" }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">RDB是否成功</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.rdb_last_bgsave_status }}</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">Key数量</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.dbSize">{{ cache.dbSize }} </div></td>
                  <td class="el-table__cell is-leaf"><div class="cell">网络入口/出口</div></td>
                  <td class="el-table__cell is-leaf"><div class="cell" v-if="cache.info">{{ cache.info.instantaneous_input_kbps }}kps/{{cache.info.instantaneous_output_kbps}}kps</div></td>
                </tr>
              </tbody>
            </table>
          </div>
        </el-card>
      </el-col>

      <el-col :span="12" class="card-box">
        <el-card>
          <div slot="header"><span><i class="el-icon-pie-chart"></i> 命令统计</span></div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <div ref="commandstats" style="height: 420px" />
          </div>
        </el-card>
      </el-col>

      <el-col :span="12" class="card-box">
        <el-card>
          <div slot="header"><span><i class="el-icon-odometer"></i> 内存信息</span></div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <div ref="usedmemory" style="height: 420px" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getCache } from "@/api/monitor/cache"
import * as echarts from "echarts"

export default {
  name: "Cache",
  data() {
    return {
      // 统计命令信息
      commandstats: null,
      // 使用内存
      usedmemory: null,
      // cache信息
      cache: [],
      onResize: null
    }
  },
  created() {
    this.getList()
    this.openLoading()
  },
  methods: {
    /** 查缓存询信息 */
    getList() {
      getCache().then((response) => {
        this.cache = response.data
        this.$modal.closeLoading()

        if (this.commandstats) {
          this.commandstats.dispose()
        }
        this.commandstats = echarts.init(this.$refs.commandstats, "macarons")
        this.commandstats.setOption({
          tooltip: {
            trigger: "item",
            formatter: "{a} <br/>{b} : {c} ({d}%)",
          },
          series: [
            {
              name: "命令",
              type: "pie",
              roseType: "radius",
              radius: [15, 95],
              center: ["50%", "38%"],
              data: response.data.commandStats,
              animationEasing: "cubicInOut",
              animationDuration: 1000,
            }
          ]
        })
        if (this.usedmemory) {
          this.usedmemory.dispose()
        }
        this.usedmemory = echarts.init(this.$refs.usedmemory, "macarons")
        this.usedmemory.setOption({
          tooltip: {
            formatter: "{b} <br/>当前内存: " + this.cache.info.used_memory_human,
          },
          series: [
            {
              name: "峰值",
              type: "gauge",
              min: 0,
              max: 100,
              detail: {
                formatter: this.getMemoryPercent(this.cache.info) + "%",
              },
              data: [
                {
                  value: this.getMemoryPercent(this.cache.info),
                  name: "内存消耗",
                }
              ]
            }
          ]
        })
        if (!this.onResize) {
          this.onResize = () => {
            this.commandstats && this.commandstats.resize()
            this.usedmemory && this.usedmemory.resize()
          }
          window.addEventListener("resize", this.onResize)
        }
      })
    },
    getMemoryPercent(info) {
      if (!info || !info.used_memory_peak_perc) {
        return 0
      }
      return Math.min(100, Math.max(0, parseFloat(info.used_memory_peak_perc)))
    },
    // 打开加载层
    openLoading() {
      this.$modal.loading("正在加载缓存监控数据，请稍候！")
    }
  },
  beforeDestroy() {
    if (this.onResize) {
      window.removeEventListener("resize", this.onResize)
    }
    if (this.commandstats) {
      this.commandstats.dispose()
      this.commandstats = null
    }
    if (this.usedmemory) {
      this.usedmemory.dispose()
      this.usedmemory = null
    }
  }
}
</script>

<style scoped>
.mb8 {
  margin-bottom: 8px;
}
</style>
