Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  # 登录注册相关API
  post '/api/auth/login', to: 'auth#login'
  post '/api/auth/register', to: 'auth#register'
  get '/api/auth/check_dup_username/:username', to: 'auth#check_dup_username'

  # 图片相关接口
  post '/api/images', to: 'images#create'
  get '/api/images/:image_id/url', to: 'images#get_image_url'
  post '/api/images/:image_id/set_user_image', to: 'images#set_user_image'
  post '/api/images/:image_id/set_shop_image', to: 'images#set_shop_image'
  post '/api/images/:image_id/set_commodity_image', to: 'images#set_commodity_image'

  # 用户相关接口
  get '/api/users/:user_id', to: 'users#show_details'
  put '/api/users/:user_id', to: 'users#update'
  get '/api/admin/users', to: 'users#show_all_for_admin'

  # 学生认证相关接口
  post '/api/students', to: 'students#certificate'
  get '/api/students/:student_id/check_dup_student_id', to: 'students#check_dup_student_id'
  get '/api/students/:student_id', to: 'students#show_details'
  get '/api/admin/students', to: 'students#show_all_for_admin'

  # 店铺相关接口
  post '/api/shops', to: 'shops#create'
  post '/api/shops/:shop_id/managers', to: 'shops#add_manager'
  delete '/api/shops/:shop_id/managers/:student_id', to: 'shops#delete_manager'
  get '/api/shops/:shop_id', to: 'shops#show_details'
  get '/api/users/:user_id/shops', to: 'shops#show_owning_and_managing_shops'
  get '/api/admin/shops', to: 'shops#show_all_for_admin'

  # 商品相关接口
  post '/api/shops/:shop_id/commodities', to: 'commodities#create'
  delete '/api/commodities/:commodity_id', to: 'commodities#delete'
  put '/api/commodities/:commodity_id', to: 'commodities#update'
  get '/api/commodities/:commodity_id', to: 'commodities#show_details'
  get '/api/commodities', to: 'commodities#show_all_for_user'
  get '/api/shops/:shop_id/commodities', to: 'commodities#show_all_for_shop'
  get '/api/admin/commodities', to: 'commodities#show_all_for_admin'
  post '/api/commodities/:commodity_id/collect', to: 'commodities#collect'
  post '/api/commodities/:commodity_id/cancel_collect', to: 'commodities#cancel_collect'
  get '/api/commodities/collect/list', to: 'commodities#show_collected'

  # 订单相关接口
  post '/api/orders', to: 'orders#create'
  post '/api/orders/:order_id/close', to: 'orders#close'
  post '/api/orders/:order_id/pay', to: 'orders#pay'
  post '/api/orders/:order_id/deliver', to: 'orders#deliver'
  post '/api/orders/:order_id/confirm', to: 'orders#confirm'
  get '/api/orders/:order_id', to: 'orders#show_details'
  get '/api/user/orders/', to: 'orders#show_all_for_user'
  get '/api/shops/:shop_id/orders', to: 'orders#show_all_for_shop'
  get '/api/admin/orders', to: 'orders#show_all_for_admin'

  # 评论相关接口
  post '/api/orders/:order_id/comments', to: 'comments#create'
  get '/api/comments/:comment_id', to: 'comments#show_details'
  get '/api/commodities/:commodity_id/comments', to: 'comments#show_all_for_commodity'

  # 文章相关接口
  post '/api/articles', to: 'articles#create'
  put '/api/articles/:article_id', to: 'articles#update'
  delete '/api/articles/:article_id', to: 'articles#delete'
  get '/api/articles/:article_id', to: 'articles#show_details'
  get '/api/articles', to: 'articles#show_all_for_user'

  # 回复相关接口
  post '/api/articles/:article_id/replies', to: 'replies#create'
  delete '/api/replies/:reply_id', to: 'replies#delete'
  put '/api/replies/:reply_id', to: 'replies#update'
  get '/api/articles/:article_id/replies', to: 'replies#show_all_for_article'


end
