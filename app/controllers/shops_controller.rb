class ShopsController < ApplicationController
  before_action :authorize_request
  before_action :check_shop_id , only: [:add_manager, :delete_manager, :show_details]
  before_action :check_student_id , only: [:add_manager, :delete_manager]
  before_action :check_user_id , only: [:show_owning_and_managing_shops]


  # [POST] /api/shops
  def create
    if @current_user.student_id == nil
      render json: {error: 'user has not completed student certification'}, status: :bad_request
    else
      data = {
        name: params[:name],
        type: params[:type],
        introduction: params[:introduction]
      }
      p @current_user
      @shop = @current_user.owning_shops.build(data)
      if @shop.save
        render json: {success: true, id: @shop.id}, status: :ok
      else
        render json: {error: @shop.errors}, status: :bad_request
      end
    end
  end

  # [POST] /api/shops/<int:shop_id>/managers
  def add_manager
    @shop = Shop.find_by(id: params[:shop_id])
    @student = Student.find_by(id: params[:student_id])
    if @shop.owner != @current_user
      render json: {error: "only the owner can add an manager"}, status: :bad_request
    elsif @shop.type == 0
      render json: {error: "only partner stores can add manager"}, status: :bad_request
    elsif @student.user == @shop.owner
      render json: {error: "the owner cannot become the manager"}, status: :bad_request
    elsif @shop.managers.include?(@student)
      render json: {error: "the student is already a manager of the store"}, status: :bad_request
    else
      @shop.managers << @student.user
      render json: {success: true}, status: :ok
    end
  end



  # [DELETE] /api/shops/<int:shop_id>/managers/<int:student_id>
  def delete_manager
    @shop = Shop.find_by(id: params[:shop_id])
    @student = Student.find_by(id: params[:student_id])
    if @shop.owner != @current_user
      render json: {error: "only the owner can delete an manager"}, status: :bad_request
    elsif @shop.type == 0
      render json: {error: "only partner stores can delete manager"}, status: :bad_request
    elsif @student == nil
      render json: {error: "student_id is invalid"}, status: :bad_request
    elsif !@shop.managers.include?(@student.user)
      render json: {error: "the student is not a manager of the shop"}, status: :bad_request
    else
      @shop.managers.delete(@student.user)
      render json: {success: true}, status: :ok
    end
  end

  # [GET] /api/shops/<int:shop_id>
  def show_details
    @shop = Shop.find_by(id: params[:shop_id])
    @owner = @shop.owner
    owner_info = {
      id: @owner.id,
      username: @owner.username,
      student_id: @owner.student.id,
      real_name: @owner.student.name
    }

    managers = []
    if @shop.type == 1
      @shop.managers.each do |manager|
        managers << {
          username: manager.username,
          student_id: manager.student.id,
          real_name: manager.student.name
        }
      end
    end

    res = {
      id: @shop.id,
      name: @shop.name,
      reg_time: @shop.created_at,
      introduction: @shop.introduction,
      type: @shop.type,
      grade: get_shop_grade(@shop),
      image_url: @shop.image == nil ? nil : @shop.image.url,
      owner_info: owner_info,
      managers: managers
    }

    render json: res, status: :ok
  end


  # [GET] /api/users/<int:user_id>/shops
  def show_owning_and_managing_shops
    @user = User.find_by(id: params[:user_id])
    owning_shops = []
    managing_shops = []

    @user.owning_shops.each do |shop|
      owning_shops << {
        id: shop.id,
        name: shop.name,
        reg_time: shop.created_at,
        type: shop.type
      }
    end

    @user.managing_shops.each do |shop|
      managing_shops << {
        id: shop.id,
        name: shop.name,
        reg_time: shop.created_at,
        type: shop.type
      }
    end

    res = {
      owning_shops: owning_shops,
      managing_shops: managing_shops
    }

    render json: res, status: :ok
  end

  # [GET] /api/admin/shops
  def show_all_for_admin
    page = params[:page].to_i
    page_size = params[:page_size] ? params[:page_size].to_i : 10
    tot_count = 0

    data = []
    Shop.all[(page-1)*page_size...page*page_size].each do |shop|
      data << {
        id: shop.id,
        name: shop.name,
        type: shop.type,
        reg_time: shop.created_at,
        owner_info: {
          user_id: shop.owner.id,
          student_id: shop.owner.student.id,
          student_name: shop.owner.student.name
        }
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

  private

  def get_shop_grade(shop)
    sum = 0.0
    cnt = 0
    shop.commodities.each do |commodity|
      commodity.orders.each do |order|
        if order.status == Order::COMMENTED
          sum += order.comment.grade
          cnt += 1
        end
      end
    end
    if cnt != 0 then sum / cnt else nil end
  end


end
