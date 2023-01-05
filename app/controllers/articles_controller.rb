class ArticlesController < ApplicationController
  before_action :authorize_request
  before_action :check_article_id, only: [:update, :delete, :show_details]

  # [POST] /api/articles
  def create
    @article = @current_user.written_articles.build(
      title: params[:title],
      content: params[:content],
      commodity_id: params[:commodity_id]
    )
    if @article.save
      render json: {success: true, id: @article.id}, status: :ok
    else
      render json: {error: @article.errors}, status: :unprocessable_entity
    end

  end

  # [PUT] /api/articles/<int:article_id>
  def update
    @article = Article.find_by(id: params[:article_id])

    if @current_user != @article.author && @current_user.role != User::ADMIN_ROLE
      render json: {error: "you are not the author or the admin"}, status: :bad_request
      return
    end

    res = @article.update(
      title: params[:title],
      content: params[:content],
      commodity_id: params[:commodity_id]
    )

    if res
      render json: {success: true}, status: :ok
    else
      render json: {error: @article.errors}, status: :ok
    end
  end

  # [DELETE] /articles/<int:article_id>
  def delete
    @article = Article.find_by(id: params[:article_id])

    if @current_user != @article.author && @current_user.role != User::ADMIN_ROLE
      render json: {error: "you are not the author or the admin"}, status: :bad_request
      return
    end

    if @article.destroy
      render json: {success: true}, status: :ok
    else
      render json: {error: @article.errors}, status: :ok
    end
  end

  # [GET] /api/articles/<int:article_id>
  def show_details
    @article = Article.find_by(id: params[:article_id])
    @author = @article.author
    @commodity = @article.commodity

    author_info = {
      id: @author.id,
      username: @author.username
    }

    commodity_info = {
      id: @commodity.id,
      name: @commodity.name,
      price: @commodity.price,
      image_url: @commodity.image.url
    } if @commodity != nil

    res = {
      id: @article.id,
      title: @article.title,
      content: @article.content,
      post_time: @article.created_at,
      author_info: author_info,
      commodity_info: @commodity == nil ? nil : commodity_info
    }

    render json: res, status: :ok
  end



  # [GET] /api/articles
  def show_all_for_user
    page = params[:page].to_i
    keyword = params[:keyword]
    page_size = params[:page_size] ? params[:page_size].to_i : 12
    tot_count = 0

    data = []
    Article.where("title LIKE ? OR content LIKE ?", "%#{keyword}%", "%#{keyword}%")
           .filter_by(params.permit(:start_date, :end_date))
           .order_by(params.permit(:create_time_asc, :create_time_desc))
           .all[(page-1)*page_size...page*page_size]
           .each do |article|
      data << {
        id: article.id,
        title: article.title,
        content: article.content,
        post_time: article.created_at,
        author_info: {
          id: article.author.id,
          username: article.author.username
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


end
