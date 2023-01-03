
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_COMMENT (orderId, data) {
    return request({
      url: `/orders/${orderId}/comments`,
      method: 'post',
      data
    })
  },

  GET_COMMENT_DETAILS (orderId) {
    return request({
      url: `/comments/${orderId}`,
      method: 'get'
    })
  },

  GET_COMMENT_LIST_OF_COMMODITY (commodityId) {
    return request({
      url: `/commodities/${commodityId}/comments`,
      method: 'get'
    })
  }
})
