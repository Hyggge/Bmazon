export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_ORDER (commodityId, data) {
    return request({
      url: `/order/new/${commodityId}`,
      method: 'post',
      data
    })
  },

  GET_ORDER_DETAILS (orderId) {
    return request({
      url: `/order/${orderId}`,
      method: 'get'
    })
  },

  MODIFY_ORDER_ADDRESS (orderId, address) {
    return request({
      url: `/order/address/${orderId}`,
      method: 'put',
      data: { address }
    })
  },

  CLOSE_ORDER (orderId) {
    return request({
      url: `/order/close/${orderId}`,
      method: 'post'
    })
  },

  PAY_ORDER (orderId) {
    return request({
      url: `/order/pay/${orderId}`,
      method: 'post'
    })
  },

  DELIVER_COMMODITY (orderId) {
    return request({
      url: `/order/deliver/${orderId}`,
      method: 'post'
    })
  },

  CONFIRM_RECEIVED (orderId) {
    return request({
      url: `/order/confirm/${orderId}`,
      method: 'post'
    })
  },

  GET_ORDER_LIST_FOR_ADMIN (params) {
    return request({
      url: '/admin/order/list',
      method: 'get',
      params
    })
  },

  GET_ORDER_LIST_FOR_USER (params) {
    return request({
      url: '/order/user/list',
      method: 'get',
      params
    })
  },

  GET_ORDER_LIST_FOR_SHOP (shopId, params) {
    return request({
      url: `/order/shop/list/${shopId}`,
      method: 'get',
      params
    })
  },

  GET_ORDER_CSV () {
    return request({
      url: '/admin/order/list_csv',
      method: 'get',
      params: { bom: true }
    })
  },

  GET_USER_CONSUME_STATISTIC_PIC (year, id) {
    return request({
      url: '/draw/consume',
      method: 'get',
      params: { year, id }
      // dataType: 'json'
    })
  }
})
