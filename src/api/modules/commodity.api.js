
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  ADD_COMMODITY (shopId, data) {
    return request({
      url: `/shops/${shopId}/commodities`,
      method: 'post',
      data
    })
  },

  DELETE_COMMODITY (commodityId) {
    return request({
      url: `/commodities/${commodityId}`,
      method: 'delete'
    })
  },

  GET_COMMODITY_DETAILS (commodityId) {
    return request({
      url: `/commodities/${commodityId}`,
      method: 'get'
    })
  },

  UPDATE_COMMODITY_DETAILS (commodityId, data) {
    return request({
      url: `/commodities/${commodityId}`,
      method: 'put',
      data
    })
  },

  GET_COMMODITY_LIST_FOR_USER (params) {
    return request({
      url: '/commodities',
      method: 'get',
      params
    })
  },

  GET_COMMODITY_LIST_FOR_SHOP (shopId, params) {
    return request({
      url: `/shops/${shopId}/commodities`,
      method: 'get',
      params
    })
  },

  GET_COMMODITY_LIST_FOR_ADMIN (params) {
    return request({
      url: '/admin/commodities',
      method: 'get',
      params
    })
  },

  COLLECT_COMMODITY (commodityId) {
    return request({
      url: `/commodities/${commodityId}/collect`,
      method: 'post'
    })
  },

  CANCEL_COLLECT_COMMODITY (commodityId) {
    return request({
      url: `/commodities/${commodityId}/cancel_collect`,
      method: 'post'
    })
  },

  GET_COLLECTED_COMMODITY_LIST (params) {
    return request({
      url: '/commodities/collect/list',
      method: 'get',
      params
    })
  }

})
