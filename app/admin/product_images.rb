ActiveAdmin.register ProductImage do
    menu false
    permit_params :image, :is_default, :product_id
    actions :all, except: [:show, :update, :edit]

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

    form do |f|
        f.semantic_errors
        f.inputs do
          f.input :image, as: :file
          f.input :is_default
          f.br
        end
        f.actions do
            f.action :submit
            f.cancel_link(admin_product_images_path(product_id: session[:product_id]))
        end
    end
    batch_action :enable_default, confirm: 'Are you sure you want to enable default these product images?' do |ids|
        temp_product_image = ProductImage.find(ids.first)
        ids.each do |id|
            product_image = ProductImage.find(id)
            product_image.is_default = true
            product_image.save(validate: false)
        end
        redirect_to admin_product_images_path(product_id: temp_product_image.product_id), notice: "Successfully enabled default #{ids.count} product image#{ids.count > 1 ? 's' : ''}"
    end
    batch_action :disable_default, confirm: 'Are you sure you want to disable default these product images?' do |ids|
        temp_product_image = ProductImage.find(ids.first)
        product_images = ProductImage.where(product_id: temp_product_image.product_id, is_default: true)
        if product_images.count - ids.count < 1
            redirect_to admin_product_images_path(product_id: temp_product_image.product_id), alert: 'The product must have at least one default image.'
        else
            ids.each do |id|
                product_image = ProductImage.find(id)
                product_image.is_default = false
                product_image.save(validate: false)
            end
            redirect_to admin_product_images_path(product_id: temp_product_image.product_id), notice: "Successfully disabled default #{ids.count} product image#{ids.count > 1 ? 's' : ''}"
        end
    end
    batch_action :destroy, confirm: 'Are you sure you want to delete these product images?' do |ids|
        temp_product_image = ProductImage.find(ids.first)
        product_id = temp_product_image.product_id
        product_images = ProductImage.where(product_id: product_id)
        if product_images.count <= ids.count
            redirect_to admin_product_images_path(product_id: temp_product_image.product_id), alert: 'The product must have at least one default image.'
        else
            ids.each do |id|
                product_image = ProductImage.find(id)
                public_id = product_image.image_url.split('/')[-1].split('.')[0]
                Cloudinary::Uploader.destroy(public_id)
                product_image.destroy
            end
            default_product_image = ProductImage.find_by(product_id: product_id, is_default: true)
            if default_product_image.nil?
                default_product_image = ProductImage.find_by(product_id: product_id)
                default_product_image.is_default = true
                default_product_image.save(validate: false)
            end
            redirect_to admin_product_images_path(product_id: product_id), notice: "Successfully deleted #{ids.count} product image#{ids.count > 1 ? 's' : ''}"
        end
    end
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
            @page_title = "Product Images For Product #{product.product_name}"
            super
        end
        def create
            unless params[:product_image][:image].nil?
                File.open(
                  Rails.root.join(
                    'public',
                    'uploads',
                    params[:product_image][:image].original_filename
                  ),
                  'wb'
                ) do |file|
                  file.write(
                    params[:product_image][:image].read
                  )
                end
                image_url = "public/uploads/#{params[:product_image][:image].original_filename}"
                product_image_url = Cloudinary::Uploader.upload(image_url)['url']
                File.delete(image_url) if File.exist?(image_url)
            end
            product_image = ProductImage.create(
                product_id: session[:product_id],
                image_url: product_image_url,
                is_default: params[:product_image][:is_default],
                created_at: Time.now,
                created_by: current_admin_user.id
            )
            if product_image.valid?
                redirect_to admin_product_images_path(product_id: product_image.product_id), notice: 'Product image was successfully created.'
            else
                redirect_to new_admin_product_image_path, alert: "Product image can't be blank."
            end
        end
        def destroy
            product_image = ProductImage.find(params[:id])
            product_images = ProductImage.where(product_id: product_image.product_id)
            if product_images.count <= 1
                redirect_to admin_product_images_path(product_id: product_image.product_id), alert: 'The product must have at least one default image.'
            else
                public_id = product_image.image_url.split('/')[-1].split('.')[0]
                Cloudinary::Uploader.destroy(public_id)
                product_image.destroy
                default_product_image = ProductImage.find_by(product_id: product_image.product_id, is_default: true)
                if default_product_image.nil?
                    default_product_image = ProductImage.find_by(product_id: product_image.product_id)
                    default_product_image.is_default = true
                    default_product_image.save(validate: false)
                end
                redirect_to admin_product_images_path(product_id: product_image.product_id), notice: 'Successfully deleted 1 product image.'
            end
        end
    end
end