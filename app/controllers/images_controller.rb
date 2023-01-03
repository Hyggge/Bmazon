class ImagesController < ApplicationController
  before_action :authorize_request
  before_action :check_image_id , only: [:get_image_url, :set_user_image, :set_shop_image, :set_commodity_image]
  before_action :check_shop_id , only: [:set_shop_image]
  before_action :check_commodity_id , only: [:set_commodity_image]

  # [POST] /api/images
  def create
    @image = Image.create(image: params[:file])
    if @image.save
      render json: {success: true, id: @image.id}, status: :ok
    else
      render json: {error: @image.errors}, status: :unprocessable_entity
    end

  end

  # [GET] /api/images/<int:image_id>/url
  def get_image_url
    @image = Image.find_by(id: params[:image_id])
    render json: {image_url: @image.url}, status: :ok
  end

  # [POST] /api/images/<int:image_id>/set_user_image
  def set_user_image
    @image = Image.find_by(id: params[:image_id])
    if @current_user.update(:image => @image)
      render json: {success: true}, status: :ok
    else
      render json: {error: @current_user}, status: :bad_request
    end
  end


  # [POST] /api/images/<int:image_id>/set_shop_image
  def set_shop_image
    @image = Image.find_by(id: params[:image_id])
    @shop = Shop.find_by(id: params[:shop_id])
    if @shop.update(:image => @image)
      render json: {success: true}, status: :ok
    else
      render json: {error: @shop}, status: :bad_request
    end
  end

  # [POST] /api/images/<int:image_id>/set_commodity_image
  def set_commodity_image
    @image = Image.find_by(id: params[:image_id])
    @commodity = Commodity.find_by(id: params[:commodity_id])
    if @commodity.update(:image => @image)
      render json: {success: true}, status: :ok
    else
      render json: {error: @commodity.errors}, status: :bad_request
    end
  end


end
