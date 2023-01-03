
export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  ADD_COMMODITY (shopId, data) {
    return request({
      url: `shop/comm/add/${shopId}`,
      method: 'post',
      data
    })
  },

  DELETE_COMMODITY (commodityId) {
    return request({
      url: `comm/${commodityId}`,
      method: 'delete'
    })
  },

  GET_COMMODITY_DETIALS (commodityId) {
    return request({
      url: `comm/${commodityId}`,
      method: 'get'
    })
  },

  UPDATE_COMMODITY_DETAILS (commodityId, data) {
    return request({
      url: `comm/${commodityId}`,
      method: 'put',
      data
    })
  },

  DELETE_COMMODITY_PARAM (paramId) {
    return request({
      url: `comm/para/${paramId}`,
      method: 'delete'
    })
  },

  UPDATE_COMMODITY_PARAM (paramId, data) {
    return request({
      url: `comm/para/${paramId}`,
      method: 'put',
      data
    })
  },

  ADD_COMMODITY_PARAM (paramId, data) {
    return request({
      url: `comm/para/add_to_para_set/${paramId}`,
      method: 'post',
      data
    })
  },

  DELETE_COMMODITY_PARAM_GROUP (paramGroupId) {
    return request({
      url: `comm/para_set/${paramGroupId}`,
      method: 'delete'
    })
  },

  UPDATE_COMMODITY_PARAM_GROUP (paramGroupId, data) {
    return request({
      url: `comm/para_set/${paramGroupId}`,
      method: 'put',
      data
    })
  },

  ADD_COMMODITY_PARAM_GROUP (paramGroupId, data) {
    return request({
      url: `comm/para_set/${paramGroupId}`,
      method: 'post',
      data
    })
  },

  GET_COMMODITY_LIST_FOR_USER (page, data) {
    return request({
      url: 'comm/list',
      method: 'post',
      params: { page, page_size: 12 },
      data
    })
  },

  GET_COMMODITY_LIST_FOR_SHOP (shopId, page, data) {
    return request({
      url: `shop/comm/list/${shopId}`,
      method: 'post',
      params: { page, page_size: 9999 },
      data
    })
  },

  COLLECT_COMMODITY (commodityId) {
    return request({
      url: `/api/commodity/collect/${commodityId}`,
      method: 'post'
    })
  },

  CANCEL_COLLECT_COMMODITY (commodityId) {
    return request({
      url: `/api/commodity/cancel_collect/${commodityId}`,
      method: 'post'
    })
  }

})
