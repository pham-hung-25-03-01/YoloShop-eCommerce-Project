class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def favorite
    begin
      if user_signed_in?
        review = Review.find_by(product_id: params[:product_id], user_id: current_user.id)
        if review.nil?
          review = Review.create!(product_id: params[:product_id], user_id: current_user.id, is_favored: true, updated_by: current_user.id)
        else
          review.is_favored = review.is_favored ? false : true
          review.updated_by = current_user.id
          review.save
        end
        count_favorite = Review.where(user_id: current_user.id, is_favored: true).count
        session[:count_favorite] = count_favorite
        render json: { review: review, count_favorite: count_favorite, is_signed_in: true }
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
        review = Review.find_by(product_id: params[:product_id], user_id: current_user.id)
        if review.nil?
          review = Review.create!(product_id: params[:product_id], user_id: current_user.id, user_score_rating: params[:score_rating], is_favored: false, updated_by: current_user.id)
        else
          review.user_score_rating = params[:score_rating]
          review.updated_by = current_user.id
          review.save
        end
        product = Product.find_by(id: params[:product_id])
        product.score_rating = ((product.score_rating * product.number_of_rates) + review.user_score_rating) / (product.number_of_rates + 1)
        product.number_of_rates = product.number_of_rates + 1
        product.save
        render json: { score_rating: product.score_rating, number_of_rates: product.number_of_rates, is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
end
