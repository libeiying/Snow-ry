import request from '@/utils/request'

// 订单统计看板
export function getOrderStats(query) {
  return request({
    url: '/business/order/stats',
    method: 'get',
    params: query
  })
}
