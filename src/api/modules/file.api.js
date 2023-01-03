import util from '@/libs/util.js'

export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  UPLOAD_FILE (file) {
    const formData = new FormData()
    formData.append('file', file)
    return request({
      url: '/file/upload',
      method: 'post',
      data: formData,
      headers: {
        Authorization: 'Bearer ' + util.cookies.get('token'),
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  DOWNLOAD_FILE (fileId) {
    return request({
      url: `/file/url/${fileId}`,
      method: 'get'
    })
  },

  SET_USER_HEAD_IMG (imgId) {
    return request({
      url: `/image/user/${imgId}`,
      method: 'post'
    })
  },

  SET_SHOP_IMG (imgId, shopId) {
    return request({
      url: `/image/shop/${imgId}`,
      method: 'post',
      data: { shop_id: shopId }
    })
  }
})
