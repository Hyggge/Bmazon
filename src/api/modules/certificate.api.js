
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_USER_CERTIFICATE (data) {
    return request({
      url: 'student/auth_req/new',
      method: 'post',
      data
    })
  },

  GET_USER_CERTIFICATE_REQ_LIST () {
    return request({
      url: 'student/auth_req/list',
      method: 'get'
    })
  },

  GET_USER_CERTIFICATE_REQ_DETAIL (reqId) {
    return request({
      url: `student/auth_req/detail/${reqId}`,
      method: 'get'
    })
  },

  GER_USER_CERTIFICATE_REQ_LIST_ADMIN (params) {
    return request({
      url: 'admin/student/auth_req/list',
      method: 'get',
      params
    })
  },

  GER_USER_CERTIFICATE_REQ_DETAIL_ADMIN (reqId) {
    return request({
      url: `admin/student/auth_req/detail/${reqId}`,
      method: 'get'
    })
  },

  DEAL_USER_CERTIFICATE (reqId, pass, comment) {
    return request({
      url: `admin/student/auth_req/detail/${reqId}`,
      method: 'put',
      data: { pass, comment }
    })
  },

  CHECK_DUP_STUDENT_ID (studentId) {
    return request({
      url: `student/auth_req/check_id/${studentId}`,
      method: 'get'
    })
  }
})
