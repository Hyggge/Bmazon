class StudentsController < ApplicationController
  before_action :authorize_request
  before_action :check_student_id, only: [:check_dup_student_id]
  before_action :check_admin_role, only: [:show_all_for_admin]

  # [POST] /api/students
  def certificate
    if Student.find_by(id: params[:student_id])
      render json: {error: "the student id has been authenticated"}
      return
    end

    data = {
      id: params[:student_id],
      name: params[:student_name],
      gender: params[:gender],
      depart: params[:depart],
      attendance_year: params[:attendance_year],
      image_id: params[:image_id],
    }

    @student = Student.create(data)
    if @student.save
      @current_user.update(:student_id => @student.id)
      render json: {success: true, id: @student.id}, status: :ok
    else
      render json: {error: @student.errors}, status: :unprocessable_entity
    end
  end

  # [GET] /api/students/<int:student_id> ""/check_dup_student_id
  def check_dup_student_id
    @student = Student.find_by(id: params[:student_id])
    if @student
      render json: {exist: true }, status: :ok
    else
      render json: {exist: false }, status: :ok
    end
  end


  # [GET] /api/admin/students
  def show_all_for_admin
    page = params[:page].to_i
    page_size = params[:page_size] ? params[:page_size].to_i : 10
    cnt = 0

    data = []
    Student.all[(page-1)*page_size...page*page_size].each do |student|
      cnt += 1
      user = student.user
      data << {
        id: cnt,
        user_id: user.id,
        username: user.username,
        student_id: student.id,
        student_name: student.name,
        req_time: student.created_at
      }
    end

    res = {tot_count: Student.all.length,
           page_all: (Student.all.length / page_size.to_f).ceil,
           page: page,
           data: data}

    render json: res, status: :ok

  end
end
