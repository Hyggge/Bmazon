class UsersController < ApplicationController

  # [GET] /api/users/<int:user_id>
  def show_details
    @user = User.find_by(id: params[:user_id])
    if @user
      res = {
        username: @user.username,
        reg_time: @user.created_at,
        phone_no: @user.phone_no,
        email: @user.email,
        signature: @user.signature,
        is_admin: @user.role,
        status: @user.student_id == nil ? 0 : 1,
        student_info: @user.student_id == nil ? nil : @user.student,
        image_url: @user.image == nil ? nil : @user.image.url
      }
      render json: res, status: :ok
    else
      render json: {error: 'user_id cannot be found'}, status: :not_found
    end

  end

  # [PUT] /api/users/<int:user_id>
  def update
    @user = User.find_by(id: params[:user_id])
    if @user.update(
      email: params[:email],
      phone_no: params[:phone_no],
      signature: params[:signature]
    )
      render json: {success: true}, status: :ok
    else
      render json: {error: 'user_id cannot be found'}, status: :not_found
    end

  end

  # [GET] /api/admin/users
  def show_all_for_admin
    data = []
    res = {tot_count: User.all.length, data: data}
    User.all.each do |user|
      data << {
        id: user.id,
        username: user.username,
        email: user.email,
        reg_time: user.created_at,
        phone_no: user.phone_no,
        signature: user.signature,
        is_admin: user.role
      }
    end
    render json: res, status: :ok
  end

end
