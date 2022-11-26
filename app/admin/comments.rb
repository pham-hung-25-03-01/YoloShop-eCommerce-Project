ActiveAdmin.register Comment, as: 'Product_Comment' do
    menu false
    actions :all, except: [:new, :create, :show, :update, :edit]

    index do
        selectable_column
        id_column
        column :user_id
        column :content
        column :created_at
        column :updated_at
        column :updated_by
        actions
    end
    
    filter :id_eq, label: 'id'
    filter :user_id_eq, label: 'user id'
    filter :content
    filter :created_at
    filter :updated_at
    filter :updated_by_eq, label: 'updated by'

    batch_action :destroy, confirm: 'Are you sure you want to delete these comments?' do |ids|
        ids.each do |id|
            Comment.update(
                id,
                is_actived: false,
                deleted_at: Time.now,
                deleted_by: current_admin_user.id
            )
        end
        redirect_to admin_product_comments_path(product_id: session[:product_id]), notice: "Successfully deleted #{ids.count} comment#{ids.count > 1 ? 's' : ''}"
    end
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
            @page_title = "Comments For Product #{product.product_name}"
            super
        end
        def destroy
            Comment.update(
                params[:id],
                is_actived: false,
                deleted_at: Time.now,
                deleted_by: current_admin_user.id
            )
            redirect_to admin_product_comments_path(product_id: session[:product_id]), notice: 'Successfully deleted 1 product image.'
        end
    end
end