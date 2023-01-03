
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  CREATE_REPLY (articleId, data) {
    return request({
      url: `/reply/article/${articleId}`,
      method: 'post',
      data
    })
  },

  MODIFY_REPLY (articleId, data) {
    return request({
      url: `/reply/${articleId}`,
      method: 'put',
      data
    })
  },

  DELETE_REPLY (articleId) {
    return request({
      url: `/reply/${articleId}`,
      method: 'delete'
    })
  },

  GET_REPLY_LIST (articleId) {
    return request({
      url: `/reply/article/${articleId}`,
      method: 'get'
    })
  }

})
