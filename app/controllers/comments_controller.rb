class CommentsController < ApplicationController
  before_action :authorize_request

  # [POST] /api/orders/<int:order_id>/comments
  def create
    @order = Order.find_by(id: params[:order_id])
    @user = @order.user
    if @user != @current_user
      render json: {error: "you have no right to comment"}, status: :bad_request
    elsif @order.status != Order::CONFIRMED
      render json: {error: "order operation sequence error"}, status: :bad_request
    else
      @comment = @order.build_comment(
        grade: params[:grade],
        content: params[:content]
      )
      if @comment.save
        @order.update(status: Order::COMMENTED)
        render json: {success: true}, status: :ok
      else
        render json: {error: @comment.errors}, status: :unprocessable_entity
      end
    end

  end

  # [GET] /api/comments/<int:comment_id>
  def show_details
    @comment = Comment.find_by(id: params[:comment_id])
    @order = @comment.order
    @user = @order.user

    order_info = {
      id: @order.id,
      price: @order.price,
      num: @order.num,
      options: @order.options.map { |option| option.description }
    }

    user_info = {
      id: @user.id,
      username: @user.username,
      image_url: @user.image == nil ? nil : @user.image.url
    }

    res = {
      id: @comment.id,
      grade: @comment.grade,
      content: @comment.content,
      comment_time: @comment.created_at,
      user_info: user_info,
      order_info: order_info
    }

    render json: res, status: :ok
  end



  # [GET] /api/commodities/<int:commodity_id>/comments
  def show_all_for_commodity
    @commodity = Commodity.find_by(id: params[:commodity_id])
    data = []
    tot_count = 0

    @commodity.orders.each do |order|
      comment = order.comment
      data << {
        id: comment.id,
        username: order.user.username,
        grade: comment.grade,
        content: comment.content,
        comment_time: comment.created_at,
        options: order.options.map { |option| option.description }
      }
      tot_count += 1
    end
    res = {
      tot_count: tot_count,
      data: data
    }
    render json: res, status: :ok
  end

end
