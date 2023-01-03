
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  USER_LOGIN (data = {}) {
    // 接口请求
    return request({
      url: 'auth/login',
      method: 'post',
      data
    })
  },

  USER_REGISTER (data = {}) {
    return request({
      url: 'auth/register',
      method: 'post',
      data
    })
  },

  CHECK_DUP_USERNAME (username) {
    return request({
      url: `/auth/check_username/${username}`,
      method: 'get'
    })
  },

  BATCH_REGISTER () {

  }
})
