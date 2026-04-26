<template>
  <div class="app-container">
    <el-card shadow="never" v-loading="loading">
      <div slot="header" class="clearfix">
        <span>{{ isEdit ? "修改文创商品" : "新增文创商品" }}</span>
        <div style="float: right">
          <el-button size="mini" @click="goBack">返 回</el-button>
          <el-button type="primary" size="mini" @click="submitForm" v-hasPermi="[isEdit ? 'business:culturalCreative:edit' : 'business:culturalCreative:add']">保 存</el-button>
        </div>
      </div>

      <el-alert
        title="填写建议：规格信息使用“键:值”格式，服务说明使用分号分隔多个短句。"
        type="info"
        :closable="false"
        show-icon
        class="mb16"
      />

      <el-form ref="form" :model="form" :rules="rules" label-width="92px">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-card class="section-card" shadow="hover">
              <div slot="header"><span>基础信息</span></div>
              <el-row :gutter="16">
                <el-col :span="12"><el-form-item label="商品编码" prop="productCode"><el-input v-model="form.productCode" placeholder="请输入商品编码" /></el-form-item></el-col>
                <el-col :span="12"><el-form-item label="商品名称" prop="title"><el-input v-model="form.title" placeholder="请输入商品名称" /></el-form-item></el-col>
                <el-col :span="12"><el-form-item label="副标题"><el-input v-model="form.subTitle" placeholder="请输入副标题" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="分类编码"><el-input v-model="form.categoryCode" placeholder="请输入分类编码" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="分类名称"><el-input v-model="form.categoryName" placeholder="请输入分类名称" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="售价(元)" prop="price"><el-input-number v-model="form.price" :min="0" :precision="2" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="划线价(元)"><el-input-number v-model="form.marketPrice" :min="0" :precision="2" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="库存"><el-input-number v-model="form.stock" :min="0" :precision="0" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="销量"><el-input-number v-model="form.salesCount" :min="0" :precision="0" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="评论数"><el-input-number v-model="form.reviewCount" :min="0" :precision="0" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="评分"><el-input-number v-model="form.reviewScore" :min="0" :max="5" :precision="1" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="6"><el-form-item label="排序"><el-input-number v-model="form.sortOrder" :min="0" :precision="0" style="width: 100%" controls-position="right" /></el-form-item></el-col>
                <el-col :span="12">
                  <el-form-item label="状态" prop="status">
                    <el-radio-group v-model="form.status">
                      <el-radio label="0">正常</el-radio>
                      <el-radio label="1">停用</el-radio>
                    </el-radio-group>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-card>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-card class="section-card" shadow="hover">
              <div slot="header"><span>图片资源</span></div>
              <el-row :gutter="16">
                <el-col :span="12">
                  <el-form-item label="封面图">
                    <image-upload v-model="form.coverImage" :limit="1" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="商品图集">
                    <image-upload v-model="imagesUploadValue" :limit="8" />
                  </el-form-item>
                </el-col>
              </el-row>
            </el-card>
          </el-col>
          <el-col :span="24">
            <el-card class="section-card" shadow="hover">
              <div slot="header"><span>扩展信息</span></div>
              <el-row :gutter="16">
                <el-col :span="12">
                  <el-form-item label="规格信息">
                    <el-input
                      type="textarea"
                      :rows="4"
                      v-model="specTextInput"
                      placeholder="每行或分号一个字段，例如：工艺:烫金; 数量:12张; 材质:350g艺术纸"
                    />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="服务说明">
                    <el-input
                      type="textarea"
                      :rows="4"
                      v-model="serviceTextInput"
                      placeholder="每行或分号一条服务，例如：24小时内发货; 支持礼盒包装; 7天无理由"
                    />
                  </el-form-item>
                </el-col>
                <el-col :span="24">
                  <el-form-item label="备注">
                    <el-input type="textarea" :rows="3" v-model="form.remark" placeholder="请输入备注" />
                  </el-form-item>
                </el-col>
              </el-row>
            </el-card>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import {
  getCulturalCreativeFull,
  addCulturalCreative,
  updateCulturalCreative
} from "@/api/business/culturalCreative"

export default {
  name: "CulturalCreativeEdit",
  data() {
    return {
      loading: false,
      form: {},
      imagesUploadValue: "",
      specTextInput: "",
      serviceTextInput: "",
      rules: {
        productCode: [{ required: true, message: "商品编码不能为空", trigger: "blur" }],
        title: [{ required: true, message: "商品名称不能为空", trigger: "blur" }],
        price: [{ required: true, message: "售价不能为空", trigger: "blur" }],
        status: [{ required: true, message: "状态不能为空", trigger: "change" }]
      }
    }
  },
  computed: {
    isEdit() {
      return !!this.form.id
    }
  },
  created() {
    this.reset()
    this.loadIfEdit()
  },
  methods: {
    reset() {
      this.form = {
        id: undefined,
        productCode: undefined,
        title: undefined,
        subTitle: undefined,
        categoryCode: undefined,
        categoryName: undefined,
        price: 0,
        marketPrice: 0,
        stock: 0,
        salesCount: 0,
        coverImage: undefined,
        imagesJson: "[]",
        specJson: "{}",
        serviceJson: "[]",
        reviewCount: 0,
        reviewScore: 0,
        sortOrder: 0,
        status: "0",
        remark: undefined
      }
      this.imagesUploadValue = ""
      this.specTextInput = ""
      this.serviceTextInput = ""
    },
    loadIfEdit() {
      const id = this.$route.params.id
      if (!id) return
      this.loading = true
      getCulturalCreativeFull(id).then(response => {
        const data = response.data || {}
        this.form = Object.assign({}, this.form, data.product || {})
        this.imagesUploadValue = this.imagesJsonToUploadValue(this.form.imagesJson)
        this.specTextInput = this.specJsonToText(this.form.specJson)
        this.serviceTextInput = this.serviceJsonToText(this.form.serviceJson)
      }).finally(() => {
        this.loading = false
      })
    },
    imagesJsonToUploadValue(imagesJson) {
      if (!imagesJson) return ""
      try {
        const arr = typeof imagesJson === "string" ? JSON.parse(imagesJson) : imagesJson
        if (!Array.isArray(arr)) return ""
        return arr.map(item => item.url || item.path).filter(Boolean).join(",")
      } catch (e) {
        return ""
      }
    },
    uploadValueToImagesJson(uploadValue) {
      if (!uploadValue) return "[]"
      const paths = uploadValue.split(",").map(v => v.trim()).filter(Boolean)
      return JSON.stringify(paths.map((url, index) => ({ url, sort: index + 1, isCover: index === 0 ? 1 : 0 })))
    },
    specJsonToText(specJson) {
      if (!specJson) return ""
      try {
        const data = typeof specJson === "string" ? JSON.parse(specJson) : specJson
        if (!data || Array.isArray(data) || typeof data !== "object") return ""
        return Object.keys(data).map(key => `${key}:${data[key]}`).join("; ")
      } catch (e) {
        return ""
      }
    },
    specTextToJson(specText) {
      if (!specText) return "{}"
      const map = {}
      specText.split(/[\n;；]/).map(item => item.trim()).filter(Boolean).forEach(item => {
        const sepIndex = item.indexOf("：") > -1 ? item.indexOf("：") : item.indexOf(":")
        if (sepIndex === -1) return
        const key = item.substring(0, sepIndex).trim()
        const value = item.substring(sepIndex + 1).trim()
        if (key) map[key] = value
      })
      return JSON.stringify(map)
    },
    serviceJsonToText(serviceJson) {
      if (!serviceJson) return ""
      try {
        const data = typeof serviceJson === "string" ? JSON.parse(serviceJson) : serviceJson
        if (!Array.isArray(data)) return ""
        return data.join("; ")
      } catch (e) {
        return ""
      }
    },
    serviceTextToJson(serviceText) {
      if (!serviceText) return "[]"
      const arr = serviceText.split(/[\n;；]/).map(item => item.trim()).filter(Boolean)
      return JSON.stringify(arr)
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (!valid) return
        const payload = Object.assign({}, this.form, {
          imagesJson: this.uploadValueToImagesJson(this.imagesUploadValue),
          specJson: this.specTextToJson(this.specTextInput),
          serviceJson: this.serviceTextToJson(this.serviceTextInput)
        })
        const api = this.isEdit ? updateCulturalCreative : addCulturalCreative
        api(payload).then(() => {
          this.$modal.msgSuccess(this.isEdit ? "修改成功" : "新增成功")
          this.goBack()
        })
      })
    },
    goBack() {
      this.$router.push("/goods/culturalCreative")
    }
  }
}
</script>

<style scoped>
.mb16 {
  margin-bottom: 16px;
}

.section-card {
  margin-bottom: 16px;
  border-radius: 8px;
}

.section-card /deep/ .el-card__header {
  background: linear-gradient(90deg, #f7faff 0%, #ffffff 100%);
  border-bottom: 1px solid #edf2ff;
  padding: 12px 16px;
}

.section-card /deep/ .el-upload-list--picture-card {
  display: flex;
  flex-wrap: wrap;
}
</style>
