
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  CREATE_ARTICLE (data) {
    return request({
      url: '/articles',
      method: 'post',
      data
    })
  },

  MODIFY_ARTICLE (articleId, data) {
    return request({
      url: `/articles/${articleId}`,
      method: 'put',
      data
    })
  },

  DELETE_ARTICLE (articleId) {
    return request({
      url: `/articles/${articleId}`,
      method: 'delete'
    })
  },

  GET_ARTICLE_DETAILS (articleId) {
    return request({
      url: `/articles/${articleId}`,
      method: 'get'
    })
  },

  GET_ARTICLE_LIST_FOR_USER (params) {
    return request({
      url: '/articles',
      method: 'get',
      params
    })
  }

})
