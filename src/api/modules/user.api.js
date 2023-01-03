
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  GET_USER_LIST_FOR_ADMIN (params) {
    // 接口请求
    return request({
      url: '/admin/users',
      method: 'get',
      params: params
    })
  },

  GET_USER_INFO (userId) {
    return request({
      url: `/users/${userId}`,
      method: 'get'
    })
  },

  UPDATE_USER_INFO (userId, data) {
    return request({
      url: `/users/${userId}`,
      method: 'put',
      data
    })
  }

})
