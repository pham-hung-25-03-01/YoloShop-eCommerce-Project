# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end
    section do
      columns do
        column do
          panel 'Unapproved orders' do
            columns class: 'mb-0 text-muted' do
              column span: 2, class: 'column pt-5-percent' do
                count = Order.where(status: 0, is_actived: true).count
                label "#{count} orders", class: 'quantity-items-summary'
              end
              column do
                label (i class: 'fa fa-fw fa-cart-plus font-size-3-em'), class: 'quantity-items-summary'
              end
            end
            div class: 'text-center' do
              a 'See more', class: '', href: admin_orders_path do
                i class: 'fa fa-fw fa-arrow-circle-right'
              end
            end
          end
        end
        column do
          panel "Current month revenue" do
            columns class: 'mb-0 text-muted' do
              column span: 2, class: 'column pt-5-percent' do
                current_month_revenue = Invoice.where(is_actived: true).where("date_part('month', updated_at) = date_part('month', now())").sum(:total_money_payment)
                label number_to_currency(current_month_revenue, precision: 0, unit: 'VND', format: '%n %u'), class: 'quantity-items-summary'
              end
              column do
                label (i class: 'fa fa-fw fa-chart-bar font-size-3-em'), class: 'quantity-items-summary'
              end
            end
            div class: 'text-center' do
              a 'See more', class: '', href: admin_invoices_path do
                i class: 'fa fa-fw fa-arrow-circle-right'
              end
            end
          end
        end
        column do
          panel 'Customers' do
            columns class: 'mb-0 text-muted' do
              column span: 2, class: 'column pt-5-percent' do
                count = User.all.count
                label "#{number_to_currency(count, precision: 0, unit: '')} users", class: 'quantity-items-summary'
              end
              column do
                label (i class: 'fa fa-fw fa-user font-size-3-em'), class: 'quantity-items-summary'
              end
            end
            div class: 'text-center' do
              a 'See more', class: '', href: admin_users_path do
                i class: 'fa fa-fw fa-arrow-circle-right'
              end
            end
          end
        end
        column do
          panel 'Products' do
            columns class: 'mb-0 text-muted' do
              column span: 2, class: 'column pt-5-percent' do
                count = Product.all.count
                label "#{number_to_currency(count, precision: 0, unit: '')} products", class: 'quantity-items-summary'
              end
              column do
                label (i class: 'fa fa-fw fa-box font-size-3-em'), class: 'quantity-items-summary'
              end
            end
            div class: 'text-center' do
              a 'See more', class: '', href: admin_products_path do
                i class: 'fa fa-fw fa-arrow-circle-right'
              end
            end
          end
        end
      end
    end

    section do
      columns do
        column do
          panel 'Days report' do
            data = Invoice.where(is_actived: true).where("date_part('year', updated_at) = date_part('year', now())").group("date(updated_at)").pluck(Arel.sql("to_char(date(updated_at), 'YYYY-MM-DD') as date, sum(total_money_payment) as total"))
            render partial: 'layouts/partials/days_revenue', locals: { data: data }
          end
        end
        column do
          panel 'Months report' do
            data = Invoice.where(is_actived: true).where("date_part('year', updated_at) = date_part('year', now())").group("date_part('month', updated_at)").pluck(Arel.sql("date_part('month', updated_at) as month, sum(total_money_payment) as total"))
            render partial: 'layouts/partials/months_revenue', locals: { data: data }
          end
        end
      end
      columns do
        column do
          panel 'Years report' do
            data = Invoice.where(is_actived: true).group("date_part('year', updated_at)").pluck(Arel.sql("date_part('year', updated_at) as year, sum(total_money_payment) as total"))
            render partial: 'layouts/partials/years_revenue', locals: { data: data }
          end
        end
        column do
          panel 'Product best seller' do
            order_details = OrderDetail.where(is_actived: true).group(:inventory_id).pluck(Arel.sql("inventory_id, sum(quantity_of_order) as total"))
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
            render partial: 'layouts/partials/product_best_seller', locals: { data: data }
          end
        end
      end
      columns do
        column do
          panel 'Products sold of current date', class: 'pb-2-percent' do
            order_details = OrderDetail.where({ orders: Order.where({ invoices: Invoice.where(is_actived: true).where('date(updated_at) = date(now())') }) }).group(:inventory_id).pluck(Arel.sql('inventory_id, sum(quantity_of_order)'))
            ids = []
            order_details.each do |order_detail|
              ids << order_detail.first
            end
            inventories = Inventory.where(id: ids)
            paginated_collection(inventories.page(params[:products_page]).per(5), download_links: true, param_name: 'products_page') do
              table_for collection do |t|
                t.column('Product') { |inventory| link_to inventory.product.product_name, admin_product_path(inventory.product_id) }
                t.column('Size') { |inventory| inventory.size }
                t.column('Color') { |inventory| link_to(image_tag(inventory.color_url, width: '50px', height: '50px', class: 'border-img'), inventory.color_url, target: '_blank') }
                t.column('Quantity') do |inventory|
                  quantity = 0
                  order_details.each do |order_detail|
                    if order_detail.first.eql?(inventory.id)
                      quantity = order_detail.last
                      break
                    end
                  end
                  quantity
                end
              end
            end
          end
        end
        column do
          panel 'Invoices of current date', class: 'pb-2-percent' do
            invoices = Invoice.where('date(created_at) = date(now())')
            paginated_collection(invoices.page(params[:invoices_page]).per(5), download_links: true, param_name: 'invoices_page') do
              table_for collection do |t|
                t.column('id') { |invoice| link_to invoice.id, admin_invoice_path(invoice.id) }
                t.column('payment') { |invoice| invoice.payment.payment_name }
                t.column('order id') { |invoice| link_to invoice.order_id, admin_order_path(invoice.order_id) }
                t.column('total money') { |invoice| number_to_currency(invoice.total_money - invoice.total_money_discount, precision: 0, unit: '') }
                t.column('total money payment') { |invoice| number_to_currency(invoice.total_money_payment, precision: 0, unit: '') }
              end
            end
          end
        end
      end
    end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
