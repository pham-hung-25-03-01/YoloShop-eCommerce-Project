class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  DEFAULT_PER_COMMENT = ENV['DEFAULT_PER_COMMENT'].to_i
  def show_more
    begin
      is_show_more = true
      all_comments = Comment.where(product_id: params[:product_id], is_actived: true).order(created_at: :DESC)
      @comments = all_comments.offset(session[:comment_offset]).limit(DEFAULT_PER_COMMENT)
      count_comments = all_comments.count
      session[:comment_offset] += DEFAULT_PER_COMMENT
      @reviews = Review.where(product_id: params[:product_id])
      is_show_more = false if session[:comment_offset] >= count_comments
      render json: { html: render_to_string(partial: 'layouts/partials/comment', collection: @comments, as: :comment, locals: { reviews: @reviews }), is_show_more: is_show_more }
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def post
    begin
      if user_signed_in?
        comment = Comment.create!(comment_params.merge(user_id: current_user.id, updated_by: current_user.id, is_actived: true))
        reviews = Review.where(product_id: params[:product_id])
        session[:comment_offset] += 1
        render json: { html: render_to_string(partial: 'layouts/partials/comment', locals: { comment: comment, reviews: reviews }), is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def comment_params
    params.require(:comment).permit(:product_id, :content)
  end
end
