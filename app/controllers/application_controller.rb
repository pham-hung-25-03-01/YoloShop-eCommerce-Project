class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :refresh_header
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_404

  def access_denied(exception)
    redirect_to '/403.html', alert: exception.message
  end
  def redirect_to_404
    redirect_to '/404.html'
  end
  def refresh_header
    if current_user.nil?
      session[:count_favorite] = nil
      session[:count_cart] = nil
      session[:total_cart] = 0
      @carts = nil
      @user_reviews = nil
    else
      session[:count_favorite] = Review.where(
        user_id: current_user.id,
        is_favored: true
      ).count
      session[:count_cart] = Cart.where(
        user_id: current_user.id
      ).count
      session[:total_cart] = Inventory.joins(:product)
                                    .joins(:carts)
                                    .where(
                                      carts: {
                                        user_id: current_user.id
                                      }
                                    ).pluck(
                                        Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity )')
                                    ).first || 0
      @carts = Cart.where(
        user_id: current_user.id
      )
      @is_cart_empty = @carts.count == 0 ? true : false
      @user_reviews = Review.where(
        user_id: current_user.id,
        is_favored: true
      )
    end
    @product_names = Product.where(
      is_actived: true
    ).order(
      product_name: :ASC
    ).pluck(:product_name).to_a.to_json.html_safe
  end
    # def devise_mapping
    #     @devise_mapping ||= Devise.mappings[:user]
    # end
    # helper_method :devise_mapping
  def new
    redirect_to_404
  end
  def show
    redirect_to_404
  end
end
