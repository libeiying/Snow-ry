import request from '@/utils/request'

export function listNortheastRouteTemplate(query) {
  return request({ url: '/business/northeastRouteTemplate/list', method: 'get', params: query })
}
export function getNortheastRouteTemplate(id) {
  return request({ url: '/business/northeastRouteTemplate/' + id, method: 'get' })
}
export function addNortheastRouteTemplate(data) {
  return request({ url: '/business/northeastRouteTemplate', method: 'post', data: data })
}
export function updateNortheastRouteTemplate(data) {
  return request({ url: '/business/northeastRouteTemplate', method: 'put', data: data })
}
export function delNortheastRouteTemplate(ids) {
  return request({ url: '/business/northeastRouteTemplate/' + ids, method: 'delete' })
}
