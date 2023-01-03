class AuthController < ApplicationController

  # [POST] /api/auth/login
  def login
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # [GET] /api/auth/register
  def register
    @user = User.new(register_params)
    if @user.save
      render json: {success: true , id: @user.id}, status: :created
    else
      render json: {error: @user.errors}, status: :unprocessable_entity
    end
  end

  # [GET] /api/auth/check_username/<str:username>
  def check_username
    @user = User.find_by_username(params[:username])
    if @user
      render json: {exist: true }, status: :ok
    else
      render json: {exist: false }, status: :ok
    end
  end



  private

  def login_params
    params.permit(:username, :password)
  end

  def register_params
    data = params.permit(:username, :password, :email, :signature, :phone_no)
    data[:role] = 0
    data
  end


end
