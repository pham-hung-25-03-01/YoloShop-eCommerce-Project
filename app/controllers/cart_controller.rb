class CartController < ApplicationController
    skip_before_action :verify_authenticity_token
    def add_to_cart
        if user_signed_in?
            inventory = Inventory.find_by(product_id: params[:product][:product_id], size: params[:product][:size], color_url: params[:product][:color], is_actived: true)
            quantity = params[:product][:quantity].to_i
            if quantity > 0
                return render json: { is_signed_in: true, is_available: false, is_error: false } if inventory.quantity_of_inventory < quantity
                cart = Cart.find_by(inventory_id: inventory.id)
                if cart.nil?
                    cart = Cart.create!(user_id: current_user.id, inventory_id: inventory.id, quantity: quantity, updated_by: current_user.id)
                    count_cart = Cart.where(user_id: current_user.id).count
                    render json: { html: render_to_string(partial: 'layouts/partials/cart_item', locals: { item: cart }), count_cart: count_cart, is_signed_in: true, is_available: true, is_error: false, is_exist: false }
                else
                    cart.quantity += quantity
                    cart.save
                    render json: { inventory_id: cart.inventory_id, quantity: cart.quantity, is_signed_in: true, is_available: true, is_error: false, is_exist: true }
                end
                
            else
                render json: { is_signed_in: true, is_error: true }
            end
        else
            render json: { is_signed_in: false }
        end
    end
end
