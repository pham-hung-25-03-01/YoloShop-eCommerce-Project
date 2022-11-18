class CartController < ApplicationController
  def add_to_cart
    begin
      if user_signed_in?
        inventory = Inventory.find_by(
          product_id: params[:product][:product_id],
          size: params[:product][:size],
          color_url: params[:product][:color],
          is_actived: true
        )
        quantity = params[:product][:quantity].to_i
        if quantity > 0 && !inventory.nil?
          return render json: {
            is_signed_in: true,
            is_available: false,
            is_error: false
          } if inventory.quantity_of_inventory < quantity
          cart = Cart.find_by(
            inventory_id: inventory.id,
            user_id: current_user.id
          )
          if cart.nil?
            cart = Cart.create!(
              user_id: current_user.id,
              inventory_id: inventory.id,
              quantity: quantity,
              updated_by: current_user.id
            )
            count_cart = Cart.where(
              user_id: current_user.id
            ).count
            total = Inventory.joins(:product)
                            .joins(:carts)
                            .where(
                                carts: {
                                    user_id: current_user.id
                                }
                            ).pluck(
                                Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity ) as total')
                            ).first || 0
            render json: {
              total: total,
              html: render_to_string(
                partial: 'layouts/partials/cart_item',
                locals: {
                  item: cart
                }
              ),
              count_cart: count_cart,
              is_signed_in: true,
              is_available: true,
              is_error: false,
              is_exist: false
            }
          else
            cart.quantity += quantity
            cart.save
            total = Inventory.joins(:product)
                            .joins(:carts)
                            .where(
                              carts: {
                                user_id: current_user.id
                              }
                            ).pluck(
                                Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity ) as total')
                            ).first || 0
            render json: {
              total: total,
              inventory_id: cart.inventory_id,
              quantity: cart.quantity,
              is_signed_in: true,
              is_available: true,
              is_error: false,
              is_exist: true
            }
          end
        else
          render json: {
            is_signed_in: true,
            is_error: true
          }
        end
      else
        render json: {
          is_signed_in: false
        }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def remove_from_cart
    begin
      if user_signed_in?
        inventory = Inventory.find_by(
          product_id: params[:product][:product_id],
          size: params[:product][:size],
          color_url: params[:product][:color],
          is_actived: true
        )
        cart = Cart.find_by(
          inventory_id: inventory.id,
          user_id: current_user.id
        )
        return render json: {
          is_signed_in: true,
          is_error: true
        } if cart.nil?
        cart.destroy
        count_cart = Cart.where(
          user_id: current_user.id
        ).count
        is_cart_empty = count_cart == 0 ? true : false
        total = Inventory.joins(:product)
                        .joins(:carts)
                        .where(
                            carts: {
                                user_id: current_user.id
                            }
                        ).pluck(
                            Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity ) as total')
                        ).first || 0
        render json: {
          is_cart_empty: is_cart_empty,
          total: total, count_cart: count_cart,
          is_signed_in: true, is_error: false,
          inventory_id: inventory.id
        }
      else
        render json: {
          is_signed_in: false
        }
      end
    rescue StandardError => e
      p e.message
      p e.backtrace
    end
  end
  def update_quantity
    if user_signed_in?
      cart = Cart.find_by(
        inventory_id: params[:product][:inventory_id],
        user_id: current_user.id
      )
      quantity_of_inventory = Inventory.find(
        params[:product][:inventory_id]
      ).quantity_of_inventory
      prev_quantity = cart.quantity.to_i
      return render json: {
        is_signed_in: true, is_error: true,
        prev_quantity: prev_quantity
      } if cart.nil? || params[:product][:quantity].to_i > quantity_of_inventory || params[:product][:quantity].to_i < 1
      cart.quantity = params[:product][:quantity]
      cart.save
      total = (cart.inventory.product.sell_price * (1 - cart.inventory.product.product_discount / 100) * cart.quantity).to_i
      cart_total = Inventory.joins(:product)
                            .joins(:carts)
                            .where(
                            carts: {
                              user_id: current_user.id
                            }
                            ).pluck(
                                Arel.sql('SUM(products.sell_price * (1 - products.product_discount / 100) * carts.quantity ) as total')
                            ).first || 0
      render json: {
        is_signed_in: true,
        is_error: false,
        quantity: cart.quantity,
        total: total,
        cart_total: cart_total
      }
    else
      render json: {
        is_signed_in: false
      }
    end
  end
end
