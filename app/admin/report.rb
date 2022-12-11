ActiveAdmin.register_page "Report" do
    menu false
    page_action :get_date_revenue, method: [:get] do
        if request.get?
            begin
                invoices = Invoice.where(is_actived: true).where("date(updated_at) = date('#{params[:date]}')")
                total = invoices.sum(:total_money_payment)
                order_details = OrderDetail.where({orders: Order.where({invoices: invoices})}, is_actived: true).group(:inventory_id).pluck(Arel.sql("inventory_id, sum(sell_price * (1 - product_discount / 100) * quantity_of_order) as total"))
                order_details.map! do |order_detail|
                  [Inventory.find(order_detail.first).product.product_name, order_detail[1]]
                end
                data = order_details.group_by(&:first).map do |order_detail|
                  sum = 0
                  order_detail.last.each do |order_detail_item|
                    sum += order_detail_item.last
                  end
                  [order_detail.first, sum]
                end
                render :json => data.to_json
            rescue StandardError => e
                p e.message
                p e.backtrace
            end
        end
    end
end