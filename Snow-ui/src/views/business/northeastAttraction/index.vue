<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="编码"><el-input v-model="queryParams.code" placeholder="景点编码" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="名称"><el-input v-model="queryParams.name" placeholder="景点名称" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="省份"><el-input v-model="queryParams.province" placeholder="省份" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="城市"><el-input v-model="queryParams.city" placeholder="城市" clearable @keyup.enter.native="handleQuery" /></el-form-item>
      <el-form-item label="状态">
        <el-select v-model="queryParams.status" clearable>
          <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item><el-button type="primary" size="mini" @click="handleQuery">搜索</el-button><el-button size="mini" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain size="mini" @click="handleAdd" v-hasPermi="['business:northeastAttraction:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain size="mini" :disabled="single" @click="handleUpdate" v-hasPermi="['business:northeastAttraction:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:northeastAttraction:remove']">删除</el-button></el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="list" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="ID" prop="id" width="80" />
      <el-table-column label="编码" prop="code" width="150" />
      <el-table-column label="名称" prop="name" min-width="160" />
      <el-table-column label="省份" prop="province" width="100" />
      <el-table-column label="城市" prop="city" width="120" />
      <el-table-column label="门票(元)" prop="ticketPrice" width="100" />
      <el-table-column label="状态" width="90">
        <template slot-scope="scope">
          <el-tag :type="getStatusTagType(scope.row.status)" size="small">{{ formatStatus(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" prop="updateTime" width="170" />
      <el-table-column label="操作" width="160" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" @click="handleUpdate(scope.row)" v-hasPermi="['business:northeastAttraction:edit']">修改</el-button>
          <el-button size="mini" type="text" @click="handleDelete(scope.row)" v-hasPermi="['business:northeastAttraction:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="open" width="820px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="景点编码" prop="code"><el-input v-model="form.code" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="景点名称" prop="name"><el-input v-model="form.name" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="省份" prop="province"><el-input v-model="form.province" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="城市" prop="city"><el-input v-model="form.city" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="区县"><el-input v-model="form.district" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="等级"><el-input v-model="form.level" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="门票(元)"><el-input-number v-model="form.ticketPrice" :precision="2" :min="0" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="状态"><el-radio-group v-model="form.status"><el-radio :label="1">启用</el-radio><el-radio :label="0">停用</el-radio></el-radio-group></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="地址"><el-input v-model="form.address" /></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="简介"><el-input v-model="form.summary" type="textarea" :rows="3" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <div slot="footer"><el-button type="primary" @click="submitForm">确 定</el-button><el-button @click="cancel">取 消</el-button></div>
    </el-dialog>
  </div>
</template>

<script>
import { listNortheastAttraction, getNortheastAttraction, addNortheastAttraction, updateNortheastAttraction, delNortheastAttraction } from "@/api/business/northeastAttraction"
export default {
  name: "NortheastAttraction",
  data() { return { loading: false, ids: [], single: true, multiple: true, showSearch: true, total: 0, list: [], open: false, title: "",
    statusOptions: [{ label: "启用", value: 1 }, { label: "停用", value: 0 }],
    queryParams: { pageNum: 1, pageSize: 10, code: undefined, name: undefined, province: undefined, city: undefined, status: undefined },
    form: {}, rules: { code: [{ required: true, message: "编码不能为空", trigger: "blur" }], name: [{ required: true, message: "名称不能为空", trigger: "blur" }], province: [{ required: true, message: "省份不能为空", trigger: "blur" }], city: [{ required: true, message: "城市不能为空", trigger: "blur" }] } } },
  created() { this.getList(); this.reset() },
  methods: {
    getList() { this.loading = true; listNortheastAttraction(this.queryParams).then(r => { this.list = r.rows || []; this.total = r.total || 0 }).finally(() => { this.loading = false }) },
    reset() { this.form = { id: undefined, code: undefined, name: undefined, province: undefined, city: undefined, district: undefined, address: undefined, level: undefined, ticketPrice: 0, summary: undefined, status: 1 }; this.resetForm("form") },
    cancel() { this.open = false; this.reset() }, handleQuery() { this.queryParams.pageNum = 1; this.getList() }, resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleSelectionChange(selection) { this.ids = selection.map(i => i.id); this.single = selection.length !== 1; this.multiple = !selection.length },
    handleAdd() { this.reset(); this.open = true; this.title = "新增东北景点" },
    handleUpdate(row) { const id = row.id || this.ids[0]; if (!id) return; this.reset(); getNortheastAttraction(id).then(r => { this.form = r.data || {}; this.open = true; this.title = "修改东北景点" }) },
    submitForm() { this.$refs["form"].validate(valid => { if (!valid) return; const api = this.form.id ? updateNortheastAttraction : addNortheastAttraction; api(this.form).then(() => { this.$modal.msgSuccess("操作成功"); this.open = false; this.getList() }) }) },
    handleDelete(row) { const ids = row.id || this.ids; this.$modal.confirm('是否删除数据项"' + ids + '"?').then(() => delNortheastAttraction(ids)).then(() => { this.$modal.msgSuccess("删除成功"); this.getList() }).catch(() => {}) },
    formatStatus(status) { return Number(status) === 1 ? "启用" : "停用" },
    getStatusTagType(status) { return Number(status) === 1 ? "success" : "danger" }
  }
}
</script>
