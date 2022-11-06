class CheckoutController < ApplicationController
  def index
    begin
      @inventories = Inventory.where(is_actived: true)
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def proceed_to_checkout
    begin
      if user_signed_in?
        count_user_cart = Cart.where(user_id: current_user.id).count
        if count_user_cart > 0
          render json: { html: render_to_string(partial: 'layouts/partials/confirm_order_information'), is_signed_in: true, is_cart_empty: false }
        else
          render json: { is_signed_in: true, is_cart_empty: true }
        end
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def back_to_cart
    begin
      if user_signed_in?
        @inventories = Inventory.where(is_actived: true)
        render json: { html: render_to_string(partial: 'layouts/partials/update_cart', locals: {carts: @carts, inventories: @inventories}), is_signed_in: true }
      else
        render json: { is_signed_in: false }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
end
