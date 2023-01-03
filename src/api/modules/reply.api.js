
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  CREATE_REPLY (articleId, data) {
    return request({
      url: `/articles/${articleId}/replies`,
      method: 'post',
      data
    })
  },

  MODIFY_REPLY (articleId, data) {
    return request({
      url: `/replies/${articleId}`,
      method: 'put',
      data
    })
  },

  DELETE_REPLY (articleId) {
    return request({
      url: `/replies/${articleId}`,
      method: 'delete'
    })
  },

  GET_REPLY_LIST (articleId) {
    return request({
      url: `/articles/${articleId}/replies`,
      method: 'get'
    })
  }

})
