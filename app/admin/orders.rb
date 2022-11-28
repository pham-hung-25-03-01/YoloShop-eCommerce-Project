ActiveAdmin.register Order do
    permit_params :ship_date, :status, :is_actived
    actions :all, except: [:new, :create, :destroy]
    index do
        selectable_column
        id_column
        column :user_id
        column :coupon_id
        column(:ship_date) { |time| time.ship_date.strftime('%B %d, %Y') unless time.ship_date.nil? }
        column 'Address' do |item|
            item.province
        end
        column :status do |item|
            if item.is_actived
                case item.status
                when 0
                    status_tag 'Pending', class: 'bg-warning'
                when 1
                    status_tag 'Shipping', class: 'bg-success'
                when 2
                    status_tag 'Completed', class: 'bg-primary'
                end
            end
        end
        column :is_actived
        column :created_at
        column :updated_at
        column :updated_by
        actions
    end
    filter :id_eq, label: 'id'
    filter :user_id_eq, label: 'user id'
    filter :coupon_id
    filter :ship_date
    filter :province, label: 'address'
    filter :status, as: :select, collection: -> { [['Pending', 0], ['Shipping', 1], ['Completed', 2]] }
    filter :is_actived
    filter :created_at
    filter :updated_at
    filter :updated_by_eq, label: 'updated by'

    form do |f|
        f.semantic_errors
        f.inputs do
            f.input :user, input_html: { readonly: true, disabled: true, value: f.object.user.email }, as: :string
            f.input :coupon_id, input_html: { readonly: true, disabled: true }
            if f.object.is_actived
                f.input :ship_date, as: :datepicker
            else
                f.input :ship_date, as: :datepicker, input_html: { readonly: true, disabled: true }
            end
            f.input :apartment_number, as: :string, input_html: { readonly: true, disabled: true }
            f.input :street, as: :string, input_html: { readonly: true, disabled: true }
            f.input :ward, as: :string, input_html: { readonly: true, disabled: true }
            f.input :district, as: :string, input_html: { readonly: true, disabled: true }
            f.input :province, as: :string, input_html: { readonly: true, disabled: true }
            if f.object.is_actived
                f.input :status, as: :select, collection: ([['Pending', 0],['Shipping', 1], ['Completed', 2]])
                f.input :is_actived
            else
                f.li do
                    "#{f.label 'Is actived'} #{f.object.is_actived ? status_tag('yes') : status_tag('no')}".html_safe
                end
            end
            f.br
            unless f.object.new_record?
                f.li "Created at: #{f.object.created_at}"
                f.li "Updated at: #{f.object.updated_at}"
                f.li do
                    admin_user = AdminUser.find(f.object.updated_by)
                    "Updated by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
                end
            end
        end
        f.actions do
            f.action :submit if f.object.is_actived
            f.cancel_link(admin_orders_path)
        end
    end

    show do |order|
        attributes_table do
            row :user
            row :coupon do
                link_to order.coupon_id, admin_coupons_path(order.coupon_id) unless order.coupon_id.nil?
            end
            row :ship_date
            row :apartment_number
            row :street
            row :ward
            row :district
            row :province
            row :status do
                if order.is_actived
                    case order.status
                    when 0
                        status_tag 'Pending', class: 'bg-warning'
                    when 1
                        status_tag 'Shipping', class: 'bg-success'
                    when 2
                        status_tag 'Completed', class: 'bg-primary'
                    end
                end
            end
            row :is_actived
            row :created_at
            row :updated_at
            row :updated_by do
                admin_user = AdminUser.find_by(id: order.updated_by)
                if admin_user.nil?
                    user = User.find(order.updated_by)
                    link_to user.email, admin_user_path(user.id)
                else
                    link_to admin_user.email, admin_admin_user_path(admin_user.id)
                end
            end
        end
        panel 'Order details' do
            total_payment = 0
            table_for OrderDetail.where(order_id: order.id) do |t|
                t.column('Product') { |order_detail| link_to  order_detail.inventory.product.product_name, admin_product_path(order_detail.inventory.product_id) }
                t.column('Size') { |order_detail| order_detail.inventory.size }
                t.column('Color') { |order_detail| link_to(image_tag(order_detail.inventory.color_url, width: '50px', height: '50px', class: 'border-img'), order_detail.inventory.color_url, target: '_blank') }
                t.column('Quantity') { |order_detail| order_detail.quantity_of_order }
                t.column('Sell price') { |order_detail| number_to_currency(order_detail.sell_price * (1 - order_detail.product_discount / 100), precision: 0, unit: '', format: '%n %u') }
                total = 0
                t.column('Total') do |order_detail|
                    total = order_detail.sell_price * (1 - order_detail.product_discount / 100) * order_detail.quantity_of_order
                    number_to_currency(total, precision: 0, unit: '', format: '%n %u')
                end
                total_payment += total
            end
            div class: 'total-payment' do
                label "Total payment: #{number_to_currency(total_payment, precision: 0, unit: 'VND', format: '%n %u')}"
            end
        end
    end
    controller do
        def update
            order = Order.find(params[:id])
            if params[:order][:ship_date].empty? || params[:order][:ship_date].nil?
                return redirect_to edit_admin_order_path(order.id), alert: "Ship date cann't be blank."
            else
                order_details = OrderDetail.where(order_id: order.id)
                order_details.update_all(updated_by: current_admin_user.id)
                case params[:order][:is_actived]
                when '1'
                    case params[:order][:status]
                    when '0'
                        unless order.status == 0
                            order_details.each do |order_detail|
                                inventory = Inventory.find(order_detail.inventory_id)
                                inventory.quantity_of_inventory += order_detail.quantity_of_order
                                inventory.save
                            end
                        end
                    when '1'
                        if order.status == 0
                            order_details.each do |order_detail|
                                inventory = Inventory.find(order_detail.inventory_id)
                                inventory.quantity_of_inventory -= order_detail.quantity_of_order
                                inventory.save
                            end
                        end
                    when '2'
                        if order.status == 0
                            order_details.each do |order_detail|
                                inventory = Inventory.find(order_detail.inventory_id)
                                inventory.quantity_of_inventory -= order_detail.quantity_of_order
                                inventory.save
                            end
                        end
                    else 
                        return redirect_to edit_admin_order_path(order.id), alert: 'Order is invalid.'
                    end
                    order.status = params[:order][:status]
                when '0'
                    case order.status
                    when 0
                        exit
                    when 1
                        order_details.each do |order_detail|
                            inventory = Inventory.find(order_detail.inventory_id)
                            inventory.quantity_of_inventory += order_detail.quantity_of_order
                            inventory.save
                        end
                    when 2
                        order_details.each do |order_detail|
                            inventory = Inventory.find(order_detail.inventory_id)
                            inventory.quantity_of_inventory += order_detail.quantity_of_order
                            inventory.save
                        end
                    else
                        return redirect_to edit_admin_order_path(order.id), alert: 'Order is invalid.'
                    end
                    order.status = 0
                    order_details.update_all(is_actived: false)
                    invoice = order.invoices.first
                    invoice.admin_user_id = nil
                    invoice.is_actived = false
                    invoice.updated_by = current_admin_user.id
                    invoice.save
                end
                order.ship_date = params[:order][:ship_date]
                order.is_actived = params[:order][:is_actived]
                order.updated_by = current_admin_user.id
                order.save
                if order.valid?
                    return redirect_to resource_path(order.id), notice: 'Order was successfully updated.'
                else
                    return redirect_to edit_admin_order_path(order.id), alert: 'Order is invalid.'
                end
            end
        end
        def edit
            @page_title = 'Hey, edit this order whose id is #' + resource.id
        end
    end
end