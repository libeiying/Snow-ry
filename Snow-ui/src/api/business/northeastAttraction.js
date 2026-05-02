import request from '@/utils/request'

export function listNortheastAttraction(query) {
  return request({ url: '/business/northeastAttraction/list', method: 'get', params: query })
}
export function getNortheastAttraction(id) {
  return request({ url: '/business/northeastAttraction/' + id, method: 'get' })
}
export function addNortheastAttraction(data) {
  return request({ url: '/business/northeastAttraction', method: 'post', data: data })
}
export function updateNortheastAttraction(data) {
  return request({ url: '/business/northeastAttraction', method: 'put', data: data })
}
export function delNortheastAttraction(ids) {
  return request({ url: '/business/northeastAttraction/' + ids, method: 'delete' })
}
