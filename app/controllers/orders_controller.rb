class OrdersController < ApplicationController
    def get_order_details
        begin
          if user_signed_in?
            order_details = OrderDetail.where(order_id: params[:order_id])
            render json: {
              is_signed_in: true,
              html: render_to_string(
                partial: 'layouts/partials/order_details',
                locals: {
                  order_id: params[:order_id],
                  order_details: order_details
                }
              )
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
end
