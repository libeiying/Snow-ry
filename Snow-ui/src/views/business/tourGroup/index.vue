<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="团编号" prop="groupCode">
        <el-input v-model="queryParams.groupCode" placeholder="请输入团编号" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="标题" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入旅游团标题" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="出发地" prop="departureCity">
        <el-input v-model="queryParams.departureCity" placeholder="请输入出发地" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="目的地" prop="destinationCity">
        <el-input v-model="queryParams.destinationCity" placeholder="请输入目的地" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in dict.type.biz_tour_group_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd" v-hasPermi="['business:tourGroup:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['business:tourGroup:remove']">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tourGroupList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" width="80" />
      <el-table-column label="团编号" align="center" prop="groupCode" min-width="130" />
      <el-table-column label="标题" align="center" prop="title" min-width="220" :show-overflow-tooltip="true" />
      <el-table-column label="封面图" align="center" min-width="110">
        <template slot-scope="scope">
          <image-preview v-if="scope.row.coverImage" :src="scope.row.coverImage" width="42" height="42" />
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="出发地" align="center" prop="departureCity" width="100" />
      <el-table-column label="目的地" align="center" prop="destinationCity" width="100" />
      <el-table-column label="天数/夜数" align="center" width="100">
        <template slot-scope="scope">{{ scope.row.days || 0 }} / {{ scope.row.nights || 0 }}</template>
      </el-table-column>
      <el-table-column label="起价(元)" align="center" prop="minPrice" width="100" />
      <el-table-column label="排序" align="center" prop="sortOrder" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.biz_tour_group_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="更新时间" align="center" prop="updateTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="220" fixed="right">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleDetail(scope.row)" v-hasPermi="['business:tourGroup:query']">详情</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)" v-hasPermi="['business:tourGroup:remove']">删除</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="760px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="团编号" prop="group.groupCode">
              <el-input v-model="form.group.groupCode" placeholder="请输入团编号（唯一）" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标题" prop="group.title">
              <el-input v-model="form.group.title" placeholder="请输入旅游团标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="副标题">
              <el-input v-model="form.group.subTitle" placeholder="请输入副标题" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="出发地">
              <el-input v-model="form.group.departureCity" placeholder="请输入出发地" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="目的地">
              <el-input v-model="form.group.destinationCity" placeholder="请输入目的地" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="天数">
              <el-input-number v-model="form.group.days" :min="0" :precision="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="夜数">
              <el-input-number v-model="form.group.nights" :min="0" :precision="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="起价(元)" prop="group.minPrice">
              <el-input-number v-model="form.group.minPrice" :min="0" :precision="2" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="排序">
              <el-input-number v-model="form.group.sortOrder" :min="0" :precision="0" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="封面图">
              <image-upload v-model="form.group.coverImage" :limit="1" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标签">
              <el-input v-model="form.group.tags" placeholder="多个标签请使用逗号分隔" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="group.status">
              <el-radio-group v-model="form.group.status">
                <el-radio v-for="dict in dict.type.biz_tour_group_status" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listTourGroup, getTourGroup, delTourGroup, addTourGroup, updateTourGroup } from "@/api/business/tourGroup"

export default {
  name: "TourGroup",
  dicts: ['biz_tour_group_status', 'biz_tour_group_detail_status'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      tourGroupList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        groupCode: undefined,
        title: undefined,
        departureCity: undefined,
        destinationCity: undefined,
        status: undefined
      },
      form: {
        group: {},
        detail: {}
      },
      rules: {
        "group.groupCode": [
          { required: true, message: "团编号不能为空", trigger: "blur" }
        ],
        "group.title": [
          { required: true, message: "标题不能为空", trigger: "blur" }
        ],
        "group.minPrice": [
          { required: true, message: "起价不能为空", trigger: "blur" }
        ],
        "group.status": [
          { required: true, message: "状态不能为空", trigger: "change" }
        ]
      }
    }
  },
  created() {
    this.getList()
    this.reset()
  },
  methods: {
    getList() {
      this.loading = true
      listTourGroup(this.queryParams).then(response => {
        this.tourGroupList = response.rows
        this.total = response.total
        this.loading = false
      }).catch(() => {
        this.loading = false
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        group: {
          id: undefined,
          groupCode: undefined,
          title: undefined,
          subTitle: undefined,
          departureCity: undefined,
          destinationCity: undefined,
          days: 0,
          nights: 0,
          minPrice: 0,
          coverImage: undefined,
          tags: undefined,
          sortOrder: 0,
          status: "0"
        },
        detail: {}
      }
      this.resetForm("form")
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
      this.reset()
      this.open = true
      this.title = "新增旅游团"
    },
    handleUpdate(row) {
      this.reset()
      const id = row.id || this.ids[0]
      getTourGroup(id).then(response => {
        const data = response.data || {}
        this.form.group = data.group || this.form.group
        this.open = true
        this.title = "修改旅游团"
      })
    },
    handleDetail(row) {
      const id = row.id || this.ids[0]
      if (!id) {
        this.$modal.msgWarning("请先选择一条记录")
        return
      }
      this.$tab.openPage("旅游团详情", "/business/tour-group-detail/index/" + id)
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) {
          return
        }
        const api = this.form.group.id ? updateTourGroup : addTourGroup
        api(this.form).then(() => {
          this.$modal.msgSuccess(this.form.group.id ? "修改成功" : "新增成功")
          this.open = false
          this.getList()
        })
      })
    },
    handleDelete(row) {
      const ids = row.id || this.ids
      this.$modal.confirm('是否确认删除旅游团编号为"' + ids + '"的数据项？').then(() => {
        return delTourGroup(ids)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>
