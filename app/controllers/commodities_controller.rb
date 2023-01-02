class CommoditiesController < ApplicationController
  before_action :authorize_request

  # [POST] /api/shops/<int:shop_id>/commodities
  def create
    @shop = Shop.find_by(id: params[:shop_id])

    # 获得commodity的基本信息
    data = {
      name: params[:name],
      total: params[:total],
      price: params[:price],
      status: params[:status],
      method: params[:method],
      introduction: params[:introduction],
      image_id: params[:image_id],
      sale: 0
    }
    # 创建commodity，并且和shop建立联系
    @commodity = @shop.commodities.build(data)
    unless @commodity.save
      render json: {error: @commodity.errors}, status: :bad_request
      return
    end
    # 获得commodity的参数信息
    param_list = params[:params]
    param_list.each do |param|
      # 创建param，并且和commodity建立联系
      @param = @commodity.params.build(name: param[:name])
      unless @param.save
        render json: {error: @param.errors}, status: :bad_request
        return
      end
      # 获得param的各个选项信息
      option_list = param[:options]
      option_list.each do |option|
        # 创建option, 并且和param建立联系
        @option = @param.options.build(description: option[:description], add: option[:add])
        unless @option.save
          render json: {error: @option.errors}, status: :bad_request
          return
        end
      end
    end

    render json: {success: true}, status: :ok
  end

  # [DELETE] /api/commodities/<int:commodity_id>
  def delete
    @commodity = Commodity.find_by(id: params[:commodity_id])
    if @commodity.shop.owner != @current_user && ! @commodity.shop.managers.include?(@current_user)
      render json: {error: "you don't have delete permission"}, status: :bad_request
    elsif @commodity.orders.length != 0 # TODO: nil?
      render json: {error: "commodities with orders cannot be deleted"}, status: :bad_request
    else
      @commodity.params.each { |param| param.destroy }
      @commodity.destroy
      render json: {success: true }, status: :ok
    end
  end

  # [GET] /api/commodities/<int:commodity_id>
  def show_details
    @commodity = Commodity.find_by(id: params[:commodity_id])
    @shop = @commodity.shop

    # 构造商品所在店铺的信息
    shop_info = {
      id: @shop.id,
      name: @shop.name,
      type: @shop.type,
      introduction: @shop.introduction
    }

    # 构造商品参数的信息
    param_list = []
    @commodity.params.each do |param|
      # 获得param下所有的option
      option_list = []
      param.options.each do |option|
        option_list << {
          description: option.description,
          add: option.description
        }
      end
      # 构造完整的param信息，加入到param_list中
      param_list << {
        name: param.name,
        options: option_list
      }
    end

    # 构造响应信息
    res = {
      id: @commodity.id,
      name: @commodity.name,
      introduction: @commodity.introduction,
      status: @commodity.status,
      total: @commodity.total,
      sale: @commodity.sale,
      price: @commodity.price,
      image_url: @commodity.image == nil ? nil : @commodity.image.url,
      shop_info: shop_info,
      params: param_list
    }

    render json: res, status: :ok
  end

  # [PUT] /api/commodities/<int:commodity_id>
  def update
    @commodity = Commodity.find_by(id: params[:commodity_id])
    if @commodity.shop.owner != @current_user && ! @commodity.shop.managers.include?(@current_user)
      render json: {error: "you don't have update permission"}, status: :bad_request
    elsif @commodity.update(status: params[:status])
      render json: {success: true}, status: :ok
    else
      render json: {error: @commodity.errors}, status: :bad_request
    end
  end

  # [GET] /api/commodities
  def show_all_for_user
    page = params[:page].to_i
    keyword = params[:keyword]
    page_size = 12
    tot_count = 0

    data = []
    Commodity.where("name LIKE ?", "%#{keyword}%" )
             .all[(page-1)*page_size...page*page_size]
             .each do |commodity|
      data << {
        id: commodity.id,
        name: commodity.name,
        introduction: commodity.introduction,
        status: commodity.status,
        total: commodity.total,
        sale: commodity.sale,
        price: commodity.price,
        grade: get_commodity_grade(commodity),
        image_url: commodity.image == nil ? nil : commodity.image.url,
        shop_info: {
          id: commodity.shop.id,
          name: commodity.shop.name
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


  # [GET] /api/shops/<int:shop_id>/commodities
  def show_all_for_shop
    @shop = Shop.find_by(id: params[:shop_id])
    unless @shop
      render json: {error: "shop_id is not valid"}, status: :bad_request
      return
    end


    page = params[:page].to_i
    keyword = params[:keyword]
    page_size = 10
    tot_count = 0

    data = []
    @shop.commodities
         .where("name LIKE ?", "%#{keyword}%" )
         .all[(page-1)*page_size...page*page_size]
         .each do |commodity|
      data << {
        id: commodity.id,
        name: commodity.name,
        introduction: commodity.introduction,
        status: commodity.status,
        total: commodity.total,
        sale: commodity.sale,
        price: commodity.price,
        grade: get_commodity_grade(commodity),
        image_url: commodity.image == nil ? nil : commodity.image.url,
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

  # [GET] /api/admin/commodities
  def show_all_for_admin
    page = params[:page].to_i
    page_size = 10
    tot_count = 0

    data = []
    Commodity.all[(page-1)*page_size...page*page_size]
             .each do |commodity|
      data << {
        id: commodity.id,
        name: commodity.name,
        introduction: commodity.introduction,
        status: commodity.status,
        total: commodity.total,
        sale: commodity.sale,
        price: commodity.price,
        grade: get_commodity_grade(commodity),
        image_url: commodity.image == nil ? nil : commodity.image.url,
        shop_info: {
          id: commodity.shop.id,
          name: commodity.shop.name
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


  # [POST] /api/commodities/<int:commodity_id>/collect
  def collect
    @commodity = Commodity.find_by(id: params[:commodity_id])
    @current_user.collecting_commodities << @commodity
    render json: {success: true}, status: :ok
  end

  # [POST] /api/commodities/<int:commodity_id>/cancel_collect
  def cancel_collect
    @commodity = Commodity.find_by(id: params[:commodity_id])
    @current_user.collecting_commodities.delete(@commodity)
    render json: {success: true}, status: :ok
  end

  # [GET] /api/commodities/collect/list
  def show_collected
    page = params[:page].to_i
    page_size = 12
    tot_count = 0

    data = []
    @current_user.collecting_commodities
         .all[(page-1)*page_size...page*page_size]
         .each do |commodity|
      data << {
        id: commodity.id,
        name: commodity.name,
        introduction: commodity.introduction,
        status: commodity.status,
        total: commodity.total,
        sale: commodity.sale,
        price: commodity.price,
        grade: get_commodity_grade(commodity),
        image_url: commodity.image == nil ? nil : commodity.image.url,
        shop_info: {
          id: commodity.shop.id,
          name: commodity.shop.name
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

  def get_commodity_grade(commodity)
    sum = 0.0
    cnt = 0
    commodity.orders.each do |order|
      sum += order.comment.grade
      cnt += 1
    end
    sum / cnt
  end


end
