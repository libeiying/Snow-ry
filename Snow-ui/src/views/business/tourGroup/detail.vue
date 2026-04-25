<template>
  <div class="app-container">
    <el-card v-loading="loading" shadow="never">
      <div slot="header" class="clearfix">
        <span>旅游团详情</span>
        <div style="float: right">
          <el-button size="mini" @click="goBack">返 回</el-button>
          <el-button type="primary" size="mini" @click="submitForm" v-hasPermi="['business:tourGroup:edit']">保 存</el-button>
        </div>
      </div>

      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-divider content-position="left">主信息</el-divider>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="团编号" prop="group.groupCode">
              <el-input v-model="form.group.groupCode" placeholder="请输入团编号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="标题" prop="group.title">
              <el-input v-model="form.group.title" placeholder="请输入标题" />
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
              <el-input v-model="form.group.tags" placeholder="多个标签请用逗号分隔" />
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

        <el-divider content-position="left">详情信息</el-divider>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="详情状态" prop="detail.status">
              <el-radio-group v-model="form.detail.status">
                <el-radio v-for="dict in dict.type.biz_tour_group_detail_status" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="详情图片">
              <image-upload v-model="detailImages" :limit="8" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="亮点">
              <editor v-model="form.detail.highlights" :min-height="120" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="行程介绍">
              <editor v-model="form.detail.itineraryText" :min-height="220" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="费用包含">
              <editor v-model="form.detail.costIncludes" :min-height="160" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="费用不含">
              <editor v-model="form.detail.costExcludes" :min-height="160" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="预订须知">
              <editor v-model="form.detail.bookingNotes" :min-height="160" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { getTourGroup, updateTourGroup } from "@/api/business/tourGroup"

export default {
  name: "TourGroupDetail",
  dicts: ["biz_tour_group_status", "biz_tour_group_detail_status"],
  data() {
    return {
      loading: false,
      detailImages: "",
      form: {
        group: {},
        detail: {}
      },
      rules: {
        "group.groupCode": [{ required: true, message: "团编号不能为空", trigger: "blur" }],
        "group.title": [{ required: true, message: "标题不能为空", trigger: "blur" }],
        "group.minPrice": [{ required: true, message: "起价不能为空", trigger: "blur" }],
        "group.status": [{ required: true, message: "状态不能为空", trigger: "change" }],
        "detail.status": [{ required: true, message: "详情状态不能为空", trigger: "change" }]
      }
    }
  },
  created() {
    this.reset()
    this.loadDetail()
  },
  methods: {
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
        detail: {
          id: undefined,
          groupId: undefined,
          highlights: "",
          itineraryText: "",
          costIncludes: "",
          costExcludes: "",
          bookingNotes: "",
          imagesJson: "",
          status: "0"
        }
      }
      this.detailImages = ""
    },
    loadDetail() {
      const id = this.$route.params.id
      if (!id) {
        this.$modal.msgError("缺少旅游团ID")
        return
      }
      this.loading = true
      getTourGroup(id).then(res => {
        const data = res.data || {}
        this.form.group = data.group || this.form.group
        this.form.detail = data.detail || this.form.detail
        this.detailImages = this.imagesJsonToUploadValue(this.form.detail.imagesJson)
      }).finally(() => {
        this.loading = false
      })
    },
    imagesJsonToUploadValue(imagesJson) {
      if (!imagesJson) return ""
      try {
        const arr = typeof imagesJson === "string" ? JSON.parse(imagesJson) : imagesJson
        if (!Array.isArray(arr)) return ""
        return arr.map(item => item.path).filter(Boolean).join(",")
      } catch (e) {
        return ""
      }
    },
    uploadValueToImagesJson(uploadValue) {
      if (!uploadValue) return "[]"
      const paths = uploadValue.split(",").map(v => v.trim()).filter(Boolean)
      return JSON.stringify(paths.map((path, index) => ({ path, alt: "", sort: index + 1 })))
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) return
        this.form.detail.imagesJson = this.uploadValueToImagesJson(this.detailImages)
        updateTourGroup(this.form).then(() => {
          this.$modal.msgSuccess("保存成功")
          this.loadDetail()
        })
      })
    },
    goBack() {
      this.$router.push("/travel/tourGroup")
    }
  }
}
</script>
