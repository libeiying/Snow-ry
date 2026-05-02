<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="起始景点"><el-input v-model="queryParams.fromAttractionCode" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="目标景点"><el-input v-model="queryParams.toAttractionCode" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="关系类型"><el-input v-model="queryParams.relationType" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" clearable>
          <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item><el-button type="primary" size="mini" @click="handleQuery">搜索</el-button><el-button size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain size="mini" @click="handleAdd" v-hasPermi="['business:northeastAttractionRelation:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:northeastAttractionRelation:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:northeastAttractionRelation:remove']">删除</el-button></el-col>
    </el-row>
    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"/>
      <el-table-column label="ID" prop="id" width="80"/>
      <el-table-column label="起始景点编码" prop="fromAttractionCode" min-width="150"/>
      <el-table-column label="目标景点编码" prop="toAttractionCode" min-width="150"/>
      <el-table-column label="关系类型" prop="relationType" width="160"/>
      <el-table-column label="距离(km)" prop="distanceKm" width="100"/>
      <el-table-column label="通行分钟" prop="travelMinutes" width="100"/>
      <el-table-column label="状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="getStatusTagType(scope.row.status)" size="small">{{ formatStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="140" fixed="right"><template slot-scope="scope"><el-button type="text" size="mini" @click="handleUpdate(scope.row)">修改</el-button><el-button type="text" size="mini" @click="handleDelete(scope.row)">删除</el-button></template></el-table-column>
    </el-table>
    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList"/>
    <el-dialog :title="title" :visible.sync="open" width="680px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px">
        <el-form-item label="起始景点编码" prop="fromAttractionCode"><el-input v-model="form.fromAttractionCode"/></el-form-item>
        <el-form-item label="目标景点编码" prop="toAttractionCode"><el-input v-model="form.toAttractionCode"/></el-form-item>
        <el-form-item label="关系类型" prop="relationType"><el-input v-model="form.relationType"/></el-form-item>
        <el-form-item label="距离(km)"><el-input-number v-model="form.distanceKm" :precision="2" :min="0" style="width:100%"/></el-form-item>
        <el-form-item label="通行分钟"><el-input-number v-model="form.travelMinutes" :min="0" style="width:100%"/></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="form.sortOrder" :min="0" style="width:100%"/></el-form-item>
        <el-form-item label="备注"><el-input v-model="form.remark" type="textarea" :rows="2"/></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio :label="1">启用</el-radio><el-radio :label="0">停用</el-radio></el-radio-group></el-form-item>
      </el-form>
      <div slot="footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>
<script>
import { listNortheastAttractionRelation, getNortheastAttractionRelation, addNortheastAttractionRelation, updateNortheastAttractionRelation, delNortheastAttractionRelation } from "@/api/business/northeastAttractionRelation"
export default {
  name: "NortheastAttractionRelation",
  data() { return { loading: false, ids: [], single: true, multiple: true, showSearch: true, total: 0, list: [], open: false, title: "", statusOptions: [{ label: "启用", value: 1 }, { label: "停用", value: 0 }], queryParams: { pageNum: 1, pageSize: 10 }, form: {}, rules: { fromAttractionCode: [{ required: true, message: "必填", trigger: "blur" }], toAttractionCode: [{ required: true, message: "必填", trigger: "blur" }], relationType: [{ required: true, message: "必填", trigger: "blur" }] } } },
  created() { this.getList(); this.reset() },
  methods: {
    getList() { this.loading = true; listNortheastAttractionRelation(this.queryParams).then(r => { this.list = r.rows || []; this.total = r.total || 0 }).finally(() => { this.loading = false }) },
    reset() { this.form = { id: undefined, fromAttractionCode: undefined, toAttractionCode: undefined, relationType: undefined, distanceKm: 0, travelMinutes: 0, sortOrder: 0, remark: undefined, status: 1 }; this.resetForm("form") },
    cancel() { this.open = false; this.reset() }, handleQuery() { this.queryParams.pageNum = 1; this.getList() }, resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(s) { this.ids = s.map(i => i.id); this.single = s.length !== 1; this.multiple = !s.length }, handleAdd() { this.reset(); this.open = true; this.title = "新增景点关系" },
    handleUpdate(row) { const id = row.id || this.ids[0]; if (!id) return; this.reset(); getNortheastAttractionRelation(id).then(r => { this.form = r.data || {}; this.open = true; this.title = "修改景点关系" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (!valid) return; const api = this.form.id ? updateNortheastAttractionRelation : addNortheastAttractionRelation; api(this.form).then(() => { this.$modal.msgSuccess("操作成功"); this.open = false; this.getList() }) }) },
    handleDelete(row) { const ids = row.id || this.ids; this.$modal.confirm('是否删除数据项"' + ids + '"?').then(() => delNortheastAttractionRelation(ids)).then(() => { this.$modal.msgSuccess("删除成功"); this.getList() }).catch(() => {}) },
    formatStatus(status) { return Number(status) === 1 ? "启用" : "停用" },
    getStatusTagType(status) { return Number(status) === 1 ? "success" : "danger" }
  }
}
</script>
