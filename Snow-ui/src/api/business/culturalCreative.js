import request from '@/utils/request'

// 查询文创商品列表
export function listCulturalCreative(query) {
  return request({
    url: '/business/culturalCreative/list',
    method: 'get',
    params: query
  })
}

// 查询文创商品完整详情（商品 + 评论）
export function getCulturalCreativeFull(id) {
  return request({
    url: '/business/culturalCreative/' + id,
    method: 'get'
  })
}

// 新增文创商品
export function addCulturalCreative(data) {
  return request({
    url: '/business/culturalCreative',
    method: 'post',
    data: data
  })
}

// 修改文创商品
export function updateCulturalCreative(data) {
  return request({
    url: '/business/culturalCreative',
    method: 'put',
    data: data
  })
}

// 删除文创商品
export function delCulturalCreative(ids) {
  return request({
    url: '/business/culturalCreative/' + ids,
    method: 'delete'
  })
}

// 导出文创商品
export function exportCulturalCreative(query) {
  return request({
    url: '/business/culturalCreative/export',
    method: 'post',
    params: query
  })
}
