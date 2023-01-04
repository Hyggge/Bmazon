class RepliesController < ApplicationController
  before_action :authorize_request
  before_action :check_article_id , only: [:create, :show_all_for_article]
  before_action :check_reply_id , only: [:update, :delete]

  # [POST] /api/articles/<int:article_id>/replies
  def create
    @article = Article.find_by(id: params[:article_id])
    refer_id = params[:refer_id]
    if refer_id != nil && Reply.find_by(id: refer_id) == nil
      render json: {error: "invalid refer_id"}, status: :bad_request
      return
    elsif refer_id != nil && ! @article.reply_ids.include?(refer_id)
      render json: {error: "the reply quoted do not belong in this article"}, status: :bad_request
      return
    end

    @reply = @article.replies.build(
      floor: @article.replies.length + 1,
      content: params[:content],
      is_deleted: 0,
      refer_id: params[:refer_id],
      user_id: @current_user.id
    )
    if @reply.save
      render json: {success: true, id: @reply.id}, status: :ok
    else
      render json: {error: @reply.errors}, status: :unprocessable_entity
    end
  end

  # [PUT] /api/replies/<int:reply_id>
  def update
    @reply = Reply.find_by(id: params[:reply_id])
    if @reply.user != @current_user && @current_user.role != User::ADMIN_ROLE
      render json: {error: "you are not the author or the admin"}, status: :bad_request
      return
    end

    if @reply.update(content: params[:content])
      render json: {success: true}, status: :ok
    else
      render json: {error: @reply.errors}, status: :bad_request
    end
  end

  # [DELETE] /api/replies/<int:reply_id>
  def delete
    @reply = Reply.find_by(id: params[:reply_id])
    if @reply.user != @current_user && @current_user.role != User::ADMIN_ROLE
      render json: {error: "you are not the author or the admin"}, status: :bad_request
      return
    end

    if @reply.update(is_deleted: 1)
      render json: {success: true}, status: :ok
    else
      render json: {error: @reply.errors}, status: :bad_request
    end
  end

  # [GET] /api/articles/<int:article_id>/replies
  def show_all_for_article
    @article = Article.find_by(id: params[:article_id])
    data = []
    tot_count = 0


    @article.replies.each do |reply|
      user = reply.user
      data << {
        id: reply.id,
        floor: reply.floor,
        content: reply.content,
        is_deleted: reply.is_deleted,
        user_info: {
          id: user.id,
          username: user.username,
          image_url: user.image == nil ? nil : user.image.url
        },
        refer_info: reply.referring_reply == nil ? nil : {
          id: reply.referring_reply.id,
          floor: reply.referring_reply.floor
        }
      }
      tot_count += 1
    end

    render json: {tot_count: tot_count, data: data}, status: :ok

  end


end
