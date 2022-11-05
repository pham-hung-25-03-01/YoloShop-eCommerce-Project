class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :count_favorite
    def count_favorite
        unless current_user.nil?
            session[:count_favorite] = Review.where(user_id: current_user.id, is_favored: true).count
            session[:count_cart] = Cart.where(user_id: current_user.id).count
            session[:total_cart] = Inventory.joins(:product).joins(:carts).where(carts: {user_id: current_user.id}).pluck(Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity )')).first || 0
            @carts = Cart.where(user_id: current_user.id)
            @is_cart_empty = @carts.count == 0 ? true : false
            @user_reviews = Review.where(user_id: current_user.id, is_favored: true)
        else
            session[:count_favorite] = nil
            session[:count_cart] = nil
            session[:total_cart] = 0
            @carts = nil
            @user_reviews = nil
        end
    end
end
