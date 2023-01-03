class ApplicationController < ActionController::API

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  protected
  def check_article_id
    @article = Article.find_by(id: params[:article_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_comment_id
    @comment = Comment.find_by(id: params[:comment_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_commodity_id
    @commodity = Commodity.find_by(id: params[:commodity_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_image_id
    @image = Image.find_by(id: params[:image_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_order_id
    @order = Order.find_by(id: params[:order_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_reply_id
    @reply = Reply.find_by(id: params[:reply_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_shop_id
    @shop = Shop.find_by(id: params[:shop_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_student_id
    @student = Student.find_by(id: params[:student_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end

  def check_user_id
    @user = User.find_by(id: params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :bad_request
  end



end
