class ImagesController < ApplicationController
  # [POST] /api/images
  def create
    @image = Image.create(image: params[:file])
    if @image.save
      render json: {id: @image.id}, status: :ok
    else
      render json: {error: 'image create error'}, status: :bad_request
    end

  end

  # [GET] /api/images/<int:image_id>/url
  def get_image_url
    @image = Image.find_by(id: params[:image_id])
    if @image
      render json: {image_url: @image.url}, status: :ok
    else
      render json: {error: 'image_id cannot be found'}, status: :not_found
    end

  end

  # [POST] /api/images/<int:image_id>/set_user_image



  # [POST] /api/images/<int:image_id>/set_shop_image



  # [POST] /api/images/<int:image_id>/set_commodity_image





end
