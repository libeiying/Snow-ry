<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="模板编码"><el-input v-model="queryParams.templateCode" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="路线标题"><el-input v-model="queryParams.title" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="城市"><el-input v-model="queryParams.city" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="路线类型"><el-input v-model="queryParams.routeType" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" clearable>
          <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item><el-button type="primary" size="mini" @click="handleQuery">搜索</el-button><el-button size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain size="mini" @click="handleAdd" v-hasPermi="['business:northeastRouteTemplate:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:northeastRouteTemplate:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:northeastRouteTemplate:remove']">删除</el-button></el-col>
    </el-row>
    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"/>
      <el-table-column label="ID" prop="id" width="80"/>
      <el-table-column label="模板编码" prop="templateCode" width="150"/>
      <el-table-column label="标题" prop="title" min-width="180"/>
      <el-table-column label="城市" prop="city" width="110"/>
      <el-table-column label="类型" prop="routeType" width="110"/>
      <el-table-column label="天数/夜数" width="90"><template slot-scope="scope">{{ scope.row.days || 0 }}/{{ scope.row.nights || 0 }}</template></el-table-column>
      <el-table-column label="预估花费" prop="estimatedCost" width="100"/>
      <el-table-column label="状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="getStatusTagType(scope.row.status)" size="small">{{ formatStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="140" fixed="right"><template slot-scope="scope"><el-button type="text" size="mini" @click="handleUpdate(scope.row)">修改</el-button><el-button type="text" size="mini" @click="handleDelete(scope.row)">删除</el-button></template></el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList"/>
    <el-dialog :title="title" :visible.sync="open" width="780px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="模板编码" prop="templateCode"><el-input v-model="form.templateCode"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="路线标题" prop="title"><el-input v-model="form.title"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="省份"><el-input v-model="form.province"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="城市"><el-input v-model="form.city"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="路线类型"><el-input v-model="form.routeType"/></el-form-item></el-col>
          <el-col :span="6"><el-form-item label="天数"><el-input-number v-model="form.days" :min="1" style="width:100%"/></el-form-item></el-col>
          <el-col :span="6"><el-form-item label="夜数"><el-input-number v-model="form.nights" :min="0" style="width:100%"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="预估花费"><el-input-number v-model="form.estimatedCost" :precision="2" :min="0" style="width:100%"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="景点编码集"><el-input v-model="form.attractionCodes"/></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio :label="1">启用</el-radio><el-radio :label="0">停用</el-radio></el-radio-group></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="路线摘要"><el-input v-model="form.summary" type="textarea" :rows="2"/></el-form-item></el-col>
        </el-row>
      </el-form>
      <div slot="footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>
<script>
import { listNortheastRouteTemplate, getNortheastRouteTemplate, addNortheastRouteTemplate, updateNortheastRouteTemplate, delNortheastRouteTemplate } from "@/api/business/northeastRouteTemplate"
export default {
  name: "NortheastRouteTemplate",
  data() { return { loading: false, ids: [], single: true, multiple: true, showSearch: true, total: 0, list: [], open: false, title: "", statusOptions: [{ label: "启用", value: 1 }, { label: "停用", value: 0 }], queryParams: { pageNum: 1, pageSize: 10 }, form: {}, rules: { templateCode: [{ required: true, message: "模板编码必填", trigger: "blur" }], title: [{ required: true, message: "标题必填", trigger: "blur" }] } } },
  created() { this.getList(); this.reset() },
  methods: {
    getList() { this.loading = true; listNortheastRouteTemplate(this.queryParams).then(r => { this.list = r.rows || []; this.total = r.total || 0 }).finally(() => { this.loading = false }) },
    reset() { this.form = { id: undefined, templateCode: undefined, title: undefined, province: undefined, city: undefined, routeType: undefined, days: 1, nights: 0, estimatedCost: 0, attractionCodes: undefined, summary: undefined, status: 1 }; this.resetForm("form") },
    cancel() { this.open = false; this.reset() }, handleQuery() { this.queryParams.pageNum = 1; this.getList() }, resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(s) { this.ids = s.map(i => i.id); this.single = s.length !== 1; this.multiple = !s.length }, handleAdd() { this.reset(); this.open = true; this.title = "新增路线模板" },
    handleUpdate(row) { const id = row.id || this.ids[0]; if (!id) return; this.reset(); getNortheastRouteTemplate(id).then(r => { this.form = r.data || {}; this.open = true; this.title = "修改路线模板" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (!valid) return; const api = this.form.id ? updateNortheastRouteTemplate : addNortheastRouteTemplate; api(this.form).then(() => { this.$modal.msgSuccess("操作成功"); this.open = false; this.getList() }) }) },
    handleDelete(row) { const ids = row.id || this.ids; this.$modal.confirm('是否删除数据项"' + ids + '"?').then(() => delNortheastRouteTemplate(ids)).then(() => { this.$modal.msgSuccess("删除成功"); this.getList() }).catch(() => {}) },
    formatStatus(status) { return Number(status) === 1 ? "启用" : "停用" },
    getStatusTagType(status) { return Number(status) === 1 ? "success" : "danger" }
  }
}
</script>
