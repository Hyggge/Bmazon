class ApplicationController < ActionController::API

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

  protected
  def check_article_id
    @article = Article.find(params[:article_id])
    p @article
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_comment_id
    @comment = Comment.find(params[:comment_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_commodity_id
    @commodity = Commodity.find(params[:commodity_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_image_id
    @image = Image.find(params[:image_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_order_id
    @order = Order.find(params[:order_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_reply_id
    @reply = Reply.find(params[:reply_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_shop_id
    @shop = Shop.find(params[:shop_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_student_id
    @student = Student.find(params[:student_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_user_id
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :bad_request
  end

  def check_admin_role
    if @current_user.role != User::ADMIN_ROLE
      render json: { error: "you are not the admin"}, status: :bad_request
    end
  end



end
