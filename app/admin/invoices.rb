ActiveAdmin.register Invoice do
    permit_params :total_money_payment, :is_actived
    actions :all, except: [:new, :create, :destroy]
    index do
        selectable_column
        id_column
        column :order_id
        column :payment_id, 'Payment' do |item|
            item.payment.payment_name
        end
        column :bank_code
        column :total_money_payment do |item|
            number_to_currency(item.total_money_payment, precision: 0, unit: '', format: '%n %u')         
        end
        column :created_at
        column :updated_at
        column 'Is accepted' do |item|
            item.is_actived ? status_tag('yes') : status_tag('no')
        end
        column 'Accepted by' do |item|
            item.admin_user_id
        end
        column :updated_by
        actions
    end
    filter :id_eq, label: 'id'
    filter :order_id_eq, label: 'order id'
    filter :payment_id, label: 'payment'
    filter :bank_code
    filter :total_money_payment
    filter :created_at
    filter :updated_at
    filter :is_actived, label: 'is accepted'
    filter :admin_user_id_eq, label: 'accepted by'
    filter :updated_by_eq, label: 'updated by'

    form do |f|
        f.semantic_errors
        f.inputs do
          f.input :order_id, as: :string, input_html: { readonly: true, disabled: true }
          f.input :payment_name, as: :string, input_html: { readonly: true, disabled: true, value: f.object.payment.payment_name }
          f.input :bank_code, input_html: { readonly: true, disabled: true }
          f.input :bank_transaction_no, input_html: { readonly: true, disabled: true }
          f.input :transaction_no, input_html: { readonly: true, disabled: true }
          f.input :total_money, input_html: { readonly: true, disabled: true, value: number_with_precision(f.object.total_money, precision: 0) }
          f.input :total_money_discount, input_html: { readonly: true, disabled: true, value: number_with_precision(f.object.total_money_discount, precision: 0) }
          if f.object.payment_id.to_s.eql?(ENV['VNPAY_E_WALLET_PAYMENT_ID'])
            f.input :total_money_payment, input_html: { readonly: true, disabled: true, value: number_with_precision(f.object.total_money_payment, precision: 0) }
          else
            f.input :total_money_payment, input_html: { value: number_with_precision(f.object.total_money_payment, precision: 0) }
          end
          f.input :is_actived
        end
        f.actions
    end
    before_update do |invoice|
        if invoice.is_actived
            invoice.admin_user_id = current_admin_user.id
        else
            invoice.admin_user_id = nil
        end
    end
    show do |invoice|
        attributes_table do
            row :order_id do
                link_to invoice.order_id, admin_order_path(invoice.order_id)
            end
            row :payment_id do
                invoice.payment.payment_name
            end
            row :bank_code
            row :bank_transaction_no
            row :transaction_no
            row :total_money do
                number_to_currency(invoice.total_money, precision: 0, unit: 'VND', format: '%n %u')
            end
            row :total_money_discount do
                number_to_currency(invoice.total_money_discount, precision: 0, unit: 'VND', format: '%n %u')
            end
            row :total_money_payment do
                number_to_currency(invoice.total_money_payment, precision: 0, unit: 'VND', format: '%n %u')
            end
            row :created_at
            row :updated_at
            row 'is accepted' do
                invoice.is_actived ? status_tag('yes') : status_tag('no')
            end
            row 'accepted by' do
                admin_user = AdminUser.find_by(id: invoice.admin_user_id)
                link_to admin_user.email, admin_admin_user_path(admin_user.id) unless admin_user.nil?
            end
            row :updated_by do
                admin_user = AdminUser.find_by(id: invoice.updated_by)
                if admin_user.nil?
                    user = User.find(invoice.updated_by)
                    link_to user.email, admin_user_path(user.id)
                else
                    link_to admin_user.email, admin_admin_user_path(admin_user.id)
                end
            end
        end
    end
    controller do
        def edit
            @page_title = 'Hey, edit this invoice whose id is #' + resource.id
        end
    end
end