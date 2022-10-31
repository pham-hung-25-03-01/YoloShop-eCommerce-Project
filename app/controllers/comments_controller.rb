class CommentsController < ApplicationController
  DEFAULT_PER_COMMENT = ENV['DEFAULT_PER_COMMENT'].to_i
  def show_more
    is_show_more = true
    all_comments = Comment.where(product_id: params[:product_id], is_actived: true).order(created_at: :DESC)
    @comments = all_comments.offset(session[:comment_offset]).limit(DEFAULT_PER_COMMENT)
    count_comments = all_comments.count
    session[:comment_offset] += DEFAULT_PER_COMMENT
    @reviews = Review.where(product_id: params[:product_id])
    is_show_more = false if session[:comment_offset] >= count_comments
    render json: { html: render_to_string(partial: 'layouts/partials/comment', collection: @comments, as: :comment, locals: { reviews: @reviews }), is_show_more: is_show_more }
  end
end
