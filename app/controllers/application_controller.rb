class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :count_favorite
    def count_favorite
        unless current_user.nil?
            session[:count_favorite] = Review.where(user_id: current_user.id, is_favored: true).count
            session[:count_cart] = Cart.where(user_id: current_user.id).count
            @carts = Cart.where(user_id: current_user.id)
        else
            session[:count_favorite] = nil
            session[:count_cart] = nil
            @carts = nil
        end
    end
end
