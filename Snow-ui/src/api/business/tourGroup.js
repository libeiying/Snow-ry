import request from '@/utils/request'

// 查询旅游团列表
export function listTourGroup(query) {
  return request({
    url: '/business/tourGroup/list',
    method: 'get',
    params: query
  })
}

// 查询旅游团详情（主表+详情）
export function getTourGroup(id) {
  return request({
    url: '/business/tourGroup/' + id,
    method: 'get'
  })
}

// 新增旅游团
export function addTourGroup(data) {
  return request({
    url: '/business/tourGroup',
    method: 'post',
    data: data
  })
}

// 修改旅游团
export function updateTourGroup(data) {
  return request({
    url: '/business/tourGroup',
    method: 'put',
    data: data
  })
}

// 删除旅游团
export function delTourGroup(ids) {
  return request({
    url: '/business/tourGroup/' + ids,
    method: 'delete'
  })
}
