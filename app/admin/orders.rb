ActiveAdmin.register Order do
    permit_params
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
            case item.status
            when 0
                status_tag 'Pending', class: 'bg-warning'
            when 1
                status_tag 'Shipping', class: 'bg-success'
            when 2
                status_tag 'Completed', class: 'bg-primary'
            end
        end
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
    filter :created_at
    filter :updated_at
    filter :updated_by_eq, label: 'updated by'
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
                case order.status
                when 0
                    status_tag 'Pending', class: 'bg-warning'
                when 1
                    status_tag 'Shipping', class: 'bg-success'
                when 2
                    status_tag 'Completed', class: 'bg-primary'
                end
            end
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
    end
    controller do
        def scoped_collection
            super.where(is_actived: true)
        end
    end
end