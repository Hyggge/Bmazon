Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # 登录注册相关API
  post '/api/auth/login', to: 'auth#login'
  post '/api/auth/register', to: 'auth#register'
  get '/api/auth/check_username/:username', to: 'auth#check_username'






end
