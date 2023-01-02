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

  # 用户相关接口
  get '/api/users/:user_id', to: 'users#show_details'
  put '/api/users/:user_id', to: 'users#update'
  get '/api/admin/users', to: 'users#show_all_for_admin'

  # 学生相关接口
  post '/api/students', to: 'students#certificate'
  get '/api/students/student_id', to: 'students#check_student_id'
  get '/api/admin/students', to: 'students#show_all_for_admin'

  # 店铺相关接口
  post '/api/shops', to: 'shops#create'
  post '/api/shops/:shop_id/managers', to: 'shops#add_manager'
  delete '/api/shops/:shop_id/managers/:student_id', to: 'shops#delete_manager'
  get '/api/shops/:shop_id', to: 'shops#show_details'
  get '/api/users/:user_id/shops', to: 'shops#show_owning_and_managing_shops'
  get '/api/admin/shops', to: 'shops#show_all_for_admin'


end
