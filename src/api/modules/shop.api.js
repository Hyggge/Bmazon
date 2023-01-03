export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  GET_SHOP_LIST (params) {
    // 接口请求
    return request({
      url: '/admin/shops',
      method: 'get',
      params: params
    })
  },

  GET_USER_SHOP_LIST (userId) {
    return request({
      url: `/users/${userId}/shops`,
      method: 'get'
    })
  },

  GET_SHOP_DETAILS (shopId) {
    return request({
      url: `/shops/${shopId}`,
      method: 'get'
    })
  },

  DELETE_SHOP_ADMIN (shopId, studentId) {
    return request({
      url: `/shops/${shopId}/managers`,
      method: 'delete',
      data: { student_id: studentId }
    })
  },

  ADD_SHOP_ADMIN (shopId, studentId) {
    return request({
      url: `/shops/${shopId}/managers`,
      method: 'post',
      data: { student_id: studentId }
    })
  },

  CREATE_NEW_SHOP (data) {
    return request({
      url: '/shops',
      method: 'post',
      data
    })
  }
})
