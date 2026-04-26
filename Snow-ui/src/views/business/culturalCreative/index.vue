<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="商品编码" prop="productCode">
        <el-input v-model="queryParams.productCode" placeholder="请输入商品编码" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="商品名称" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入商品名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="商品分类" prop="categoryName">
        <el-input v-model="queryParams.categoryName" placeholder="请输入商品分类" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" value="0" />
          <el-option label="停用" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:culturalCreative:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:culturalCreative:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:culturalCreative:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['business:culturalCreative:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="productList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" width="80" />
      <el-table-column label="商品编码" align="center" prop="productCode" min-width="130" />
      <el-table-column label="商品名称" align="center" prop="title" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="封面图" align="center" width="90">
        <template slot-scope="scope">
          <image-preview v-if="scope.row.coverImage" :src="scope.row.coverImage" width="38" height="38" />
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="分类" align="center" prop="categoryName" width="110" />
      <el-table-column label="售价(元)" align="center" prop="price" width="100" />
      <el-table-column label="库存" align="center" prop="stock" width="80" />
      <el-table-column label="销量" align="center" prop="salesCount" width="80" />
      <el-table-column label="评分" align="center" width="80">
        <template slot-scope="scope">{{ scope.row.reviewScore || 0 }}</template>
      </el-table-column>
      <el-table-column label="评论数" align="center" prop="reviewCount" width="90" />
      <el-table-column label="状态" align="center" width="80">
        <template slot-scope="scope">
          <span>{{ formatStatus(scope.row.status) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" align="center" prop="updateTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)" v-hasPermi="['business:culturalCreative:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)" v-hasPermi="['business:culturalCreative:edit']">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:culturalCreative:remove']">删除</el-button>
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
import {
  listCulturalCreative,
  delCulturalCreative
} from "@/api/business/culturalCreative"

export default {
  name: "CulturalCreative",
  data() {
    return {
      loading: false,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      productList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        productCode: undefined,
        title: undefined,
        categoryName: undefined,
        status: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listCulturalCreative(this.queryParams).then(response => {
        this.productList = response.rows || []
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
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.$tab.openPage("新增文创商品", "/business/cultural-creative-edit/index")
    },
    handleUpdate(row) {
      const target = row || this.productList.find(item => item.id === this.ids[0])
      if (!target || !target.id) {
        this.$modal.msgWarning("请先选择一条记录")
        return
      }
      this.$tab.openPage("修改文创商品", "/business/cultural-creative-edit/index/" + target.id)
    },
    handleDetail(row) {
      const id = row.id || this.ids[0]
      if (!id) {
        this.$modal.msgWarning("请先选择一条记录")
        return
      }
      this.$tab.openPage("文创商品详情", "/business/cultural-creative-detail/index/" + id)
    },
    handleDelete(row) {
      const ids = row.id || this.ids
      this.$modal.confirm('是否确认删除文创商品编号为"' + ids + '"的数据项？').then(() => {
        return delCulturalCreative(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download('/business/culturalCreative/export', {
        ...this.queryParams
      }, `culturalCreative_${new Date().getTime()}.xlsx`)
    },
    formatStatus(status) {
      return status === "0" ? "正常" : "停用"
    }
  }
}
</script>
