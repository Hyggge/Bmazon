export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_ORDER (data) {
    return request({
      url: '/orders',
      method: 'post',
      data
    })
  },

  GET_ORDER_DETAILS (orderId) {
    return request({
      url: `/orders/${orderId}`,
      method: 'get'
    })
  },

  CLOSE_ORDER (orderId) {
    return request({
      url: `/orders/${orderId}/close`,
      method: 'post'
    })
  },

  PAY_ORDER (orderId) {
    return request({
      url: `/orders/${orderId}/pay`,
      method: 'post'
    })
  },

  DELIVER_COMMODITY (orderId) {
    return request({
      url: `/orders/${orderId}/deliver`,
      method: 'post'
    })
  },

  CONFIRM_RECEIVED (orderId) {
    return request({
      url: `/orders/${orderId}/confirm`,
      method: 'post'
    })
  },

  GET_ORDER_LIST_FOR_ADMIN (params) {
    return request({
      url: '/admin/orders',
      method: 'get',
      params
    })
  },

  GET_ORDER_LIST_FOR_USER (params) {
    return request({
      url: '/user/orders',
      method: 'get',
      params
    })
  },

  GET_ORDER_LIST_FOR_SHOP (shopId, params) {
    return request({
      url: `/shops/${shopId}/orders`,
      method: 'get',
      params
    })
  }
})
