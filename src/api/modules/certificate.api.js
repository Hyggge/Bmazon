
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  SUBMIT_USER_CERTIFICATE (data) {
    return request({
      url: '/students',
      method: 'post',
      data
    })
  },

  GET_USER_CERTIFICATE_LIST_ADMIN (params) {
    return request({
      url: '//admin/students',
      method: 'get',
      params
    })
  },

  CHECK_DUP_STUDENT_ID (studentId) {
    return request({
      url: `students/${studentId}/check_dup_student_id`,
      method: 'get'
    })
  }
})
