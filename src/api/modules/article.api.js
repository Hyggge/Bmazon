
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  CREATE_ARTICLE (data) {
    return request({
      url: '/article/new',
      method: 'post',
      data
    })
  },

  MODIFY_ARTICLE (articleId, data) {
    return request({
      url: `/article/${articleId}`,
      method: 'put',
      data
    })
  },

  GET_ARTICLE_DETAILS (articleId) {
    return request({
      url: `/article/${articleId}`,
      method: 'get'
    })
  },

  GET_ARTICLE_LIST_FOR_USER (params) {
    return request({
      url: '/article/list',
      method: 'get',
      params
    })
  },

  CLICK_STAR (articleId) {
    return request({
      url: `/article_op/star/${articleId}`,
      method: 'post'
    })
  },

  CANCEL_STAR (articleId) {
    return request({
      url: `/article_op/cancel_star/${articleId}`,
      method: 'post'
    })
  },

  CLICK_COLLECT (articleId) {
    return request({
      url: `/article_op/collect/${articleId}`,
      method: 'post'
    })
  },

  CANCEL_COLLECT (articleId) {
    return request({
      url: `/article_op/cancel_collect/${articleId}`,
      method: 'post'
    })
  },

  GET_COLLECTED_ARTICLE_LIST (page) {
    return request({
      url: '/article/collect/list',
      method: 'get',
      params: { page }
    })
  }

})
