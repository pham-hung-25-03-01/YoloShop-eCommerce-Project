class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def favorite
    begin
      if user_signed_in?
        review = Review.find_by(product_id: params[:review][:product_id], user_id: current_user.id)
        if review.nil?
          review = Review.create!(product_id: params[:review][:product_id], user_id: current_user.id, is_favored: true, updated_by: current_user.id)
        else
          review.is_favored = review.is_favored ? false : true
          review.updated_by = current_user.id
          review.save
        end
        count_favorite = Review.where(user_id: current_user.id, is_favored: true).count
        render json: { html: render_to_string(partial: 'layouts/partials/favorite_item', locals: { item: review }), review: review, count_favorite: count_favorite, is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def rating
    begin
      if user_signed_in?
        review = Review.find_by(product_id: params[:review][:product_id], user_id: current_user.id)
        product = Product.find_by(id: params[:review][:product_id])
        if review.nil?
          review = Review.create!(review_params.merge(user_id: current_user.id, is_favored: false, updated_by: current_user.id))
          product.score_rating = ((product.score_rating * product.number_of_rates) + review.user_score_rating) / (product.number_of_rates + 1)
          product.number_of_rates = product.number_of_rates + 1
        else
          total_score_rating = (product.score_rating * product.number_of_rates) - review.user_score_rating.to_i
          if product.number_of_rates == 0
            product.number_of_rates = 1
          else
            product.number_of_rates = product.number_of_rates + 1 unless review.user_score_rating.is_a?(Integer)
          end
          review.user_score_rating = params[:review][:user_score_rating]
          review.updated_by = current_user.id
          review.save
          product.score_rating = (total_score_rating + review.user_score_rating) / product.number_of_rates
        end
        product.save
        render json: { score_rating: product.score_rating, number_of_rates: product.number_of_rates, user_id: current_user.id, is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def review_params
    params.require(:review).permit(:product_id, :user_score_rating)
  end
end
