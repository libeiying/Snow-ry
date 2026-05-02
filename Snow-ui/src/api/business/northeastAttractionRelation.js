import request from '@/utils/request'

export function listNortheastAttractionRelation(query) {
  return request({ url: '/business/northeastAttractionRelation/list', method: 'get', params: query })
}
export function getNortheastAttractionRelation(id) {
  return request({ url: '/business/northeastAttractionRelation/' + id, method: 'get' })
}
export function addNortheastAttractionRelation(data) {
  return request({ url: '/business/northeastAttractionRelation', method: 'post', data: data })
}
export function updateNortheastAttractionRelation(data) {
  return request({ url: '/business/northeastAttractionRelation', method: 'put', data: data })
}
export function delNortheastAttractionRelation(ids) {
  return request({ url: '/business/northeastAttractionRelation/' + ids, method: 'delete' })
}
