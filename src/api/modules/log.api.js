import util from '@/libs/util.js'

export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  GET_LOG_LIST (params) {
    return request({
      url: 'admin/log/list',
      method: 'get',
      params: params
    })
  },

  GET_LOG_CSV () {
    return request({
      url: 'admin/log/list_csv',
      method: 'get',
      params: { bom: true }
    })
  }
})
