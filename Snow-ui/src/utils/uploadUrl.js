import { isExternal } from '@/utils/validate'

/**
 * 将 /common/upload 返回结果解析为浏览器可用的绝对地址（兼容本地 /profile/... 与 OSS 完整 https URL）
 * @param {Object} res AjaxResult，需含 url 或 fileName
 * @param {string} [baseApi] 默认 process.env.VUE_APP_BASE_API
 */
export function resolveUploadResponseUrl(res, baseApi) {
  if (!res) {
    return ''
  }
  const base = baseApi != null ? baseApi : process.env.VUE_APP_BASE_API
  let u = res.url || res.fileName
  if (!u) {
    return ''
  }
  u = String(u).trim()
  if (isExternal(u) || /^https?:\/\//i.test(u)) {
    if (/\s/.test(u)) {
      try {
        return encodeURI(u)
      } catch (e) {
        return u
      }
    }
    return u
  }
  return base + (u.startsWith('/') ? u : '/' + u)
}
