Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # 登录注册相关API
  post '/api/auth/login', to: 'auth#login'
  post '/api/auth/register', to: 'auth#register'
  get '/api/auth/check_username/:username', to: 'auth#check_username'

  # 图片相关接口
  post '/api/images', to: 'images#create'
  get '/api/images/:image_id/url', to: 'images#get_image_url'
  post '/api/images/<int:image_id>/set_user_image', to: 'images#set_user_image'
  post '/api/images/<int:image_id>/set_shop_image', to: 'images#set_shop_image'
  post '/api/images/<int:image_id>/set_commodity_image', to: 'images#set_commodity_image'




end
