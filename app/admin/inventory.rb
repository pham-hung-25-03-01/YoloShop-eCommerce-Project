ActiveAdmin.register Inventory do
    actions :all, except: [:destroy]
    permit_params :product_id, :size, :color, :quantity_of_inventory, :is_actived
    index do
        selectable_column
        id_column
        column :product_id
        column :size
        column 'Color' do |item|
            link_to(image_tag(item.color_url, width: '70px', height: '70px', class: 'border-img'), item.color_url, target: '_blank') unless item.color_url.nil?
        end
        column 'Quantity' do |item|
            item.quantity_of_inventory
        end
        column :is_actived
        column :created_at
        column :updated_at
        column :created_by
        column :updated_by
        actions
    end
    
    filter :id_eq, label: 'id'
    filter :product_id_eq, label: 'product id'
    filter :size
    filter :quantity_of_inventory, as: :numeric
    filter :is_actived
    filter :created_at
    filter :updated_at
    filter :created_by_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'

    form do |f|
        f.semantic_errors
        f.inputs do
            if f.object.new_record?
                f.input :product_id, as: :select, collection: Product.all.collect { |product| [product.product_name, product.id] }
                f.input :size, as: :string
                f.input :color, as: :file, label: 'Color'
                f.input :quantity_of_inventory, label: 'Quantity'
            else
                f.li do
                    f.label 'Active inventory'
                end
                f.br
            end
            f.input :is_actived
        end
        f.actions
    end
    show do |inventory|
        attributes_table do
          row 'product' do
            link_to inventory.product.product_name, admin_product_path(inventory.product_id)
          end
          row :size
          row 'color' do
            link_to(image_tag(inventory.color_url, width: '70px', height: '70px', class: 'border-img'), inventory.color_url, target: '_blank')
          end
          row 'quantity' do
            inventory.quantity_of_inventory
          end
          row ' ' do
            link_to 'Manage inventory', admin_inventory_quantity_logs_path(inventory_id: inventory.id)
          end
          row :is_actived
          row :created_at
          row :updated_at
          row :created_by do
            admin_user = AdminUser.find(inventory.created_by)
            link_to admin_user.email, admin_admin_user_path(admin_user.id)
          end
          row :updated_by do
            admin_user = AdminUser.find(inventory.updated_by)
            link_to admin_user.email, admin_admin_user_path(admin_user.id)
          end
        end
    end
    controller do
        def create
            unless params[:inventory][:color].nil?
                File.open(
                  Rails.root.join(
                    'public',
                    'uploads',
                    params[:inventory][:color].original_filename
                  ),
                  'wb'
                ) do |file|
                  file.write(
                    params[:inventory][:color].read
                  )
                end
                image_url = "public/uploads/#{params[:inventory][:color].original_filename}"
                color_url = Cloudinary::Uploader.upload(image_url)['url']
                File.delete(image_url) if File.exist?(image_url)
            end
            inventory = Inventory.create(
                product_id: params[:inventory][:product_id],
                size: params[:inventory][:size],
                color_url: color_url,
                quantity_of_inventory: params[:inventory][:quantity_of_inventory],
                is_actived: params[:inventory][:is_actived],
                created_by: current_admin_user.id,
                updated_by: current_admin_user.id
            )
            if inventory.valid?
                redirect_to resource_path(inventory.id), notice: 'Inventory was successfully created.'
            else
                redirect_to new_admin_inventory_path, alert: "Inventory is invalid."
            end
        end
        def edit
            @page_title = 'Hey, edit this inventory whose id is #' + resource.id
        end
    end
end