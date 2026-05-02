import request from '@/utils/request'

// 查询订单列表
export function listOrder(query) {
  return request({
    url: '/business/order/list',
    method: 'get',
    params: query
  })
}

// 查询订单详情
export function getOrderDetail(orderNo) {
  return request({
    url: '/business/order/' + orderNo,
    method: 'get'
  })
}

// 订单发货
export function shipOrder(orderNo) {
  return request({
    url: '/business/order/' + orderNo + '/ship',
    method: 'put'
  })
}
