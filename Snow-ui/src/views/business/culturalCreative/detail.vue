<template>
  <div class="app-container">
    <el-card v-loading="loading" shadow="never">
      <div slot="header" class="clearfix">
        <span>文创商品详情</span>
        <div style="float: right">
          <el-button size="mini" @click="goBack">返 回</el-button>
        </div>
      </div>

      <el-divider content-position="left">商品信息</el-divider>
      <el-descriptions :column="3" border size="small">
        <el-descriptions-item label="商品ID">{{ product.id || "-" }}</el-descriptions-item>
        <el-descriptions-item label="商品编码">{{ product.productCode || "-" }}</el-descriptions-item>
        <el-descriptions-item label="商品名称">{{ product.title || "-" }}</el-descriptions-item>
        <el-descriptions-item label="副标题" :span="3">{{ product.subTitle || "-" }}</el-descriptions-item>
        <el-descriptions-item label="分类编码">{{ product.categoryCode || "-" }}</el-descriptions-item>
        <el-descriptions-item label="分类名称">{{ product.categoryName || "-" }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ product.status === "0" ? "正常" : "停用" }}</el-descriptions-item>
        <el-descriptions-item label="售价(元)">{{ product.price || 0 }}</el-descriptions-item>
        <el-descriptions-item label="划线价(元)">{{ product.marketPrice || 0 }}</el-descriptions-item>
        <el-descriptions-item label="库存">{{ product.stock || 0 }}</el-descriptions-item>
        <el-descriptions-item label="销量">{{ product.salesCount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="评分">{{ product.reviewScore || 0 }}</el-descriptions-item>
        <el-descriptions-item label="评论数">{{ product.reviewCount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ product.updateTime || "-" }}</el-descriptions-item>
      </el-descriptions>

      <el-row class="mt16">
        <el-col :span="24">
          <el-form label-width="100px" size="small">
            <el-form-item label="封面图">
              <el-image
                v-if="product.coverImage"
                :src="product.coverImage"
                :preview-src-list="[product.coverImage]"
                fit="cover"
                class="thumb-image"
              />
              <span v-else>-</span>
            </el-form-item>
            <el-form-item label="商品图集">
              <el-image
                v-for="(img, index) in detailImages"
                :key="index"
                :src="img"
                :preview-src-list="detailImages"
                fit="cover"
                class="thumb-image"
              />
              <span v-if="!detailImages.length">-</span>
            </el-form-item>
            <el-form-item label="规格信息">
              <pre class="detail-json">{{ formatJson(product.specJson) }}</pre>
            </el-form-item>
            <el-form-item label="服务说明">
              <pre class="detail-json">{{ formatJson(product.serviceJson) }}</pre>
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>

      <el-divider content-position="left">评论信息</el-divider>
      <el-table :data="comments" border size="small" max-height="360">
        <el-table-column label="评论ID" align="center" prop="id" width="90" />
        <el-table-column label="用户昵称" align="center" prop="userNickname" width="120" />
        <el-table-column label="评分" align="center" prop="score" width="70" />
        <el-table-column label="内容" align="center" prop="content" min-width="300" :show-overflow-tooltip="true" />
        <el-table-column label="点赞数" align="center" prop="likeCount" width="80" />
        <el-table-column label="匿名" align="center" width="80">
          <template slot-scope="scope">{{ scope.row.isAnonymous === "1" ? "是" : "否" }}</template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      </el-table>
      <div v-if="!comments.length" class="empty-comment-text">暂无评论数据</div>
    </el-card>
  </div>
</template>

<script>
import { getCulturalCreativeFull } from "@/api/business/culturalCreative"

export default {
  name: "CulturalCreativeDetail",
  data() {
    return {
      loading: false,
      product: {},
      comments: [],
      detailImages: []
    }
  },
  created() {
    this.loadDetail()
  },
  methods: {
    loadDetail() {
      const id = this.$route.params.id
      if (!id) {
        this.$modal.msgError("缺少文创商品ID")
        return
      }
      this.loading = true
      getCulturalCreativeFull(id).then(response => {
        const data = response.data || {}
        this.product = data.product || {}
        this.comments = data.comments || []
        this.detailImages = this.parseImageUrls(this.product.imagesJson)
      }).finally(() => {
        this.loading = false
      })
    },
    parseImageUrls(imagesJson) {
      if (!imagesJson) return []
      try {
        const arr = typeof imagesJson === "string" ? JSON.parse(imagesJson) : imagesJson
        if (!Array.isArray(arr)) return []
        return arr.map(item => item.url || item.path).filter(Boolean)
      } catch (e) {
        return []
      }
    },
    formatJson(content) {
      if (!content) return "-"
      if (typeof content !== "string") return JSON.stringify(content, null, 2)
      try {
        const parsed = JSON.parse(content)
        return JSON.stringify(parsed, null, 2)
      } catch (e) {
        return content
      }
    },
    goBack() {
      this.$router.push("/goods/culturalCreative")
    }
  }
}
</script>

<style scoped>
.mt16 {
  margin-top: 16px;
}

.detail-json {
  margin: 0;
  white-space: pre-wrap;
  line-height: 20px;
  color: #606266;
  background-color: #fafafa;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  padding: 8px 10px;
}

.empty-comment-text {
  text-align: center;
  color: #909399;
  margin-top: 10px;
}

.thumb-image {
  width: 56px;
  height: 56px;
  border-radius: 4px;
  margin-right: 8px;
  border: 1px solid #ebeef5;
}
</style>
