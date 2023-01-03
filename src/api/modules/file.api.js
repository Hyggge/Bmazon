import util from '@/libs/util.js'

export default ({ service, request, serviceForMock, requestForMock, mock, faker, tools }) => ({

  UPLOAD_IMAGE (file) {
    const formData = new FormData()
    formData.append('file', file)
    return request({
      url: '/images',
      method: 'post',
      data: formData,
      headers: {
        Authorization: 'Bearer ' + util.cookies.get('token'),
        'Content-Type': 'multipart/form-data'
      }
    })
  },

  DOWNLOAD_IMAGE (fileId) {
    return request({
      url: `/images/${fileId}/url`,
      method: 'get'
    })
  },

  SET_USER_HEAD_IMG (imgId) {
    return request({
      url: `/images/${imgId}/set_user_image`,
      method: 'post'
    })
  },

  SET_SHOP_IMG (imgId, shopId) {
    return request({
      url: `/images/${imgId}/set_shop_image`,
      method: 'post',
      data: { shop_id: shopId }
    })
  }
})
