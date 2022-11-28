ActiveAdmin.register Invoice do
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
    filter :admin_user_id_eq, label: 'accepted by'
    filter :updated_by_eq, label: 'updated by'
    show do |invoice|
        attributes_table do
            row :order_id
            row :bank_code
            row :bank_transaction_no
            row :transaction_no
            row :total_money
            row :total_money_discount
            row :total_money_payment
            row :created_at
            row :updated_at
            row 'accepted by' do
                admin_user = AdminUser.find_by(invoice.admin_user_id)
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
end