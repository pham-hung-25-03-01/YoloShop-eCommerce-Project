ActiveAdmin.register ProductPriceLog do
    menu false
    actions :all, except: [:new, :create, :show, :edit, :update]

    index do
        selectable_column
        id_column
        column :product_id
        column :import_price do |item|
            number_to_currency(item.import_price, precision: 0, unit: '')
        end
        column :sell_price do |item|
            number_to_currency(item.sell_price, precision: 0, unit: '')
        end
        column :created_at
        column :updated_at
        column 'Created by' do |item|
            item.admin_user_id
        end
        column :updated_by
        actions
    end

    filter :id_eq, label: 'id'
    filter :product_id_eq, label: 'product id'
    filter :import_price, as: :numeric
    filter :sell_price, as: :numeric
    filter :created_at
    filter :updated_at
    filter :admin_user_id_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'

    controller do
        def scoped_collection
            if params[:product_id].nil?
                super.where(is_actived: true)
            else
                super.where(product_id: params[:product_id], is_actived: true)
            end
        end
        def index
            session[:product_id] = params[:product_id]
            product = Product.find(params[:product_id])
            @page_title = "Manage For Product #{product.product_name}"
            super
        end
    end
end