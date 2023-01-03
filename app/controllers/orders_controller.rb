class OrdersController < ApplicationController
  before_action :authorize_request


  # [POST] /api/orders
  def create
    @commodity = Commodity.find_by(id: params[:commodity_id])
    if @commodity.total < @commodity.sale + params[:num].to_i
      render json: {error: "not enough commodities"}, status: :bad_request
      return
    end

    data = {
      status: Order::CREATED,
      price: calc_price(@commodity, params[:selected_options], params[:num]),
      num: params[:num],
      address: params[:address],
      note: params[:note],
      commodity_id: @commodity.id,
      user_id: @current_user.id
    }

    @order = Order.create(data)
    if @order.save
      params[:selected_options].each do |option_id|
        @option = Option.find_by(id: option_id)
        @order.options << @option
      end
      @commodity.sale += @order.num
      @commodity.save
      render json: {success: true, id: @order.id}, status: :ok
    else
      render json: {error: @order.errors}, status: :unprocessable_entity
    end

  end

  # [POST] /api/orders/<int:order_id>/close/
  def close
    @order = Order.find_by(id: params[:order_id])
    @commodity = @order.commodity
    @user = @order.user

    if @order.status != Order::CREATED
      render json: {error: "order operation sequence error"}, status: :bad_request
    elsif @current_user != @user
      render json: {error: "you don't have permission to close the order"}, status: :bad_request
    else
      @order.update(status: Order::CLOSED, close_time: Time.now)
      @commodity.sale -= @order.num
      @commodity.save
      render json: {success: true}, status: :ok
    end

  end

  # [POST] /api/orders/<int:order_id>/pay/
  def pay
    @order = Order.find_by(id: params[:order_id])
    @commodity = @order.commodity
    @user = @order.user

    if @order.status != Order::CREATED
      render json: {error: "order operation sequence error"}, status: :bad_request
    elsif @current_user != @user
      render json: {error: "you don't have permission to pay the order"}, status: :bad_request
    else
      @order.update(status: Order::PAID, pay_time: Time.now)
      render json: {success: true}, status: :ok
    end
  end

  # [POST] /api/orders/<int:order_id>/deliver
  def deliver
    @order = Order.find_by(id: params[:order_id])
    @commodity = @order.commodity
    @user = @order.user

    if @order.status != Order::PAID
      render json: {error: "order operation sequence error"}, status: :bad_request
    elsif @current_user != @commodity.shop.owner && ! @commodity.shop.managers.include?(@current_user)
      render json: {error: "you don't have permission to deliver the commodity"}, status: :bad_request
    else
      @order.update(status: Order::DELIVERED, deliver_time: Time.now)
      render json: {success: true}, status: :ok
    end
  end

  # [POST] /api/orders/<int:order_id>/confirm
  def confirm
    @order = Order.find_by(id: params[:order_id])
    @commodity = @order.commodity
    @user = @order.user

    if @order.status != Order::DELIVERED
      render json: {error: "order operation sequence error"}, status: :bad_request
    elsif @current_user != @user
      render json: {error: "you don't have permission to confirm the order"}, status: :bad_request
    else
      @order.update(status: Order::CONFIRMED, confirm_time: Time.now)
      render json: {success: true}, status: :ok
    end
  end

  # [GET] /api/orders/<int:order_id>
  def show_details
    @order = Order.find_by(id: params[:order_id])
    @commodity = @order.commodity
    @user = @order.user
    user_info = {
      id: @user.id,
      username: @user.username
    }

    commodity_info = {
      id: @commodity.id,
      name: @commodity.name,
      price: @commodity.price,
      shop_id: @commodity.shop.id,
      shop_name: @commodity.shop.name
    }

    selected_options = []
    @order.options.each do |option|
      selected_options << {
        id: option.id,
        description: option.description,
        add: option.add.to_f # TODO: precision control
      }
    end

    res = {
      id: @order.id,
      num: @order.num,
      price: @order.price,
      address: @order.address,
      note: @order.note,
      status: @order.status,
      start_time: @order.created_at,
      pay_time: @order.pay_time,
      deliver_time: @order.deliver_time,
      confirm_time: @order.confirm_time,
      close_time: @order.close_time,
      selected_options: selected_options,
      user_info: user_info,
      commodity_info: commodity_info
    }

    render json: res, status: :ok

  end

  # [GET] /api/user/orders
  def show_all_for_user
    page = params[:page].to_i
    page_size = 10
    tot_count = 0
    data = []
    p @current_user.orders
    @current_user.orders
                 .all[(page-1)*page_size...page*page_size]
                 .each do |order|
      @commodity = order.commodity
      commodity_info = {
        id: @commodity.id,
        name: @commodity.name,
        price: @commodity.price,
        shop_id: @commodity.shop.id,
        shop_name: @commodity.shop.name
      }
      data << {
        id: order.id,
        num: order.num,
        price: order.price,
        status: order.status,
        start_time: order.created_at,
        commodity_info: commodity_info
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

  # [GET] /api/shops/<shop_id>/orders
  def show_all_for_shop
    page = params[:page].to_i
    page_size = 10
    tot_count = 0
    data = []

    @shop = Shop.find_by(id: params[:shop_id])
    all_orders = @shop.commodities.inject([]) do |ans, commodity|
      ans + commodity.orders.to_a
    end
    all_orders[(page-1)*page_size...page*page_size].each do |order|
      @commodity = order.commodity
      @user = order.user
      user_info = {
        id: @user.id,
        username: @user.username
      }
      commodity_info = {
        id: @commodity.id,
        name: @commodity.name,
        price: @commodity.price,
      }
      data << {
        id: order.id,
        num: order.num,
        price: order.price,
        status: order.status,
        start_time: order.created_at,
        user_info: user_info,
        commodity_info: commodity_info
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

  # [GET] /api/admin/orders
  def show_all_for_admin
    page = params[:page].to_i
    page_size = 10
    tot_count = 0
    data = []

    Order.all[(page-1)*page_size...page*page_size]
         .each do |order|
      @commodity = order.commodity
      @user = order.user
      user_info = {
        id: @user.id,
        username: @user.username
      }
      commodity_info = {
        id: @commodity.id,
        name: @commodity.name,
        price: @commodity.price,
        shop_id: @commodity.shop.id,
        shop_name: @commodity.shop.name
      }
      data << {
        id: order.id,
        num: order.num,
        price: order.price,
        status: order.status,
        start_time: order.created_at,
        user_info: user_info,
        commodity_info: commodity_info
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

  def calc_price(commodity, selected_options, num)
    base_price = commodity.price
    selected_options.each do |option_id|
      option = Option.find_by(id: option_id)
      base_price += option.add
    end
    base_price * num
  end

end
