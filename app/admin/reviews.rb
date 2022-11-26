ActiveAdmin.register Review do
    menu false
    actions :all, except: [:new, :create, :show, :update, :edit, :destroy]

    index do
        selectable_column
        column :user_id
        column :user_score_rating
        column :is_favored
        column :created_at
        column :updated_at
        column :updated_by
        actions
    end
    
    filter :user_id_eq, label: 'user id'
    filter :user_score_rating, as: :numeric
    filter :is_favored
    filter :created_at
    filter :updated_at
    filter :updated_by_eq, label: 'updated by'

    controller do
        def scoped_collection
            if params[:product_id].nil?
                super
            else
                super.where(product_id: params[:product_id])
            end
        end
        def index
            session[:product_id] = params[:product_id]
            product = Product.find(params[:product_id])
            @page_title = "Reviews For Product #{product.product_name}"
            super
        end
    end
end