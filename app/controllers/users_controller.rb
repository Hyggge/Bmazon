class UsersController < ApplicationController
  before_action :authorize_request
  before_action :check_user_id, only: [:show_details, :update]
  before_action :check_admin_role, only: [:show_all_for_admin]

  # [GET] /api/users/<int:user_id>
  def show_details
    @user = User.find_by(id: params[:user_id])

    student_info = {
      id: @user.student.id,
      name: @user.student.name,
      depart: @user.student.depart,
      attendance_year: @user.student.attendance_year,
    } if @user.student

    res = {
      id: @user.id,
      username: @user.username,
      reg_time: @user.created_at,
      phone_no: @user.phone_no,
      email: @user.email,
      signature: @user.signature,
      role: @user.role,
      status: @user.student_id == nil ? 0 : 1,
      student_info: @user.student_id == nil ? nil : student_info,
      image_url: @user.image == nil ? nil : @user.image.url
    }

    render json: res, status: :ok


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
      render json: {error: @user.errors}, status: :not_found
    end

  end

  # [GET] /api/admin/users
  def show_all_for_admin
    page = params[:page].to_i
    page_size = 10
    tot_count = 0

    data = []
    User.all[(page-1)*page_size...page*page_size].each do |user|
      data << {
        id: user.id,
        username: user.username,
        email: user.email,
        reg_time: user.created_at,
        phone_no: user.phone_no,
        signature: user.signature,
        is_admin: user.role
      }
      tot_count += 1
    end

    res = {
      tot_count: tot_count,
      page_all: (tot_count / page_size.to_f).ceil,
      page: page,
      data: data
    }

    render json: res, status: :ok
  end

end
