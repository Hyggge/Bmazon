
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_COMMENT (orderId, data) {
    return request({
      url: `/order/comment/${orderId}`,
      method: 'post',
      data
    })
  },

  GET_COMMENT_DETAILS (orderId) {
    return request({
      url: `/comment/${orderId}`,
      method: 'get'
    })
  },

  GET_COMMENT_LIST_OF_COMMODITY (commodityId) {
    return request({
      url: `/commodity/comment/list/${commodityId}`,
      method: 'get'
    })
  },

  GET_GRADE_OF_COMMODITY (commodityId) {
    return request({
      url: `/commodity/comment/avg_grade/${commodityId}`,
      method: 'get'
    })
  }
})
