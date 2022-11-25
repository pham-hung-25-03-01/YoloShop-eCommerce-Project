ActiveAdmin.register ProductImage do
    menu false
    actions :all, except: [:show]

    index do
        selectable_column
        id_column
        column 'Image' do |item|
            link_to(image_tag(item.image_url, width: '70px', height: '70px'), item.image_url, target: '_blank')
        end
        column :is_default
        column :created_at
        column :created_by
        actions
    end
    
    filter :id_eq, label: 'id'
    filter :is_default
    filter :created_at
    filter :created_by_eq, label: 'created by'

    controller do
        def scoped_collection
          super.where(product_id: params[:product_id])
        end
        def index
            product = Product.find(params[:product_id])
            @page_title = "Product Image For Product #{product.product_name}"
            super
        end
    end
end