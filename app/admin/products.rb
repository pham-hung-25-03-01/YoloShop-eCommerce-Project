ActiveAdmin.register Product do
    permit_params :image, :event_id, :supplier_id, :product_group_id, :category_id, :age_id, :product_name, :origin, :description,
    :gender, :warranty, :import_price, :sell_price, :product_discount, :shipping, :score_rating, :number_of_rates, :is_available, :is_actived
    actions :all, except: [:destroy]
  
    index do
      selectable_column
      id_column
      column :product_name
      column 'Image' do |item|
        unless item.product_images.nil?
          image_url = item.product_images.find_by(is_default: true).image_url
          link_to(image_tag(image_url, width: '70px', height: '70px', class: 'border-img'), image_url, target: '_blank')
        end
      end
      column :supplier_id do |item|
        item.supplier.nil? ? '' : item.supplier.supplier_name
      end
      column :category_id do |item|
        item.category.nil? ? '' : item.category.category_name
      end
      column :age_id do |item|
        item.age.nil? ? '' : item.age.age_name
      end
      column :origin
      column :gender do |item|
        item.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no') unless item.gender.nil?
      end
      column :warranty
      column :sell_price do |item|
        number_to_currency(item.sell_price, precision: 0, unit: '')
      end
      column :product_discount do |item|
        item.product_discount.round(1)
      end
      column :score_rating do |item|
        item.score_rating.round(1)
      end
      column 'Show' do |item|
        item.is_actived ? status_tag('yes') : status_tag('no')
      end
      actions
    end
    filter :id_eq, label: 'id'
    filter :product_name
    filter :supplier, as: :select, collection: -> { Supplier.where(is_actived: true).pluck(:supplier_name, :id) }
    filter :category, as: :select, collection: -> { Category.where(is_actived: true).pluck(:category_name, :id) }
    filter :age, as: :select, collection: -> { Age.where(is_actived: true).pluck(:age_name, :id) }
    filter :origin
    filter :gender, as: :select, collection: -> { [['Male', true], ['Female', false]] }
    filter :warranty, as: :numeric
    filter :sell_price, as: :numeric
    filter :product_discount, as: :numeric
    filter :score_rating, as: :numeric
    filter :is_actived, label: 'show'
  
    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :product_name, as: :string
        if f.object.new_record?
          f.input :image, as: :file
        else
          f.li do
            "#{f.label 'Product images'} #{f.a 'Edit product images', href: admin_product_images_path(product_id: f.object.id)}".html_safe
          end
        end
        f.input :product_group, as: :select, collection: ProductGroup.where(is_actived: true).collect { |product_group| [product_group.product_group_name, product_group.id] }
        f.input :supplier, as: :select, collection: Supplier.where(is_actived: true).collect { |supplier| [supplier.supplier_name, supplier.id] }
        f.input :category, as: :select, collection: Category.where(is_actived: true).collect { |category| [category.category_name, category.id] }
        f.input :age, as: :select, collection: Age.where(is_actived: true).collect { |age| [age.age_name, age.id] }
        f.input :event, as: :select, collection: Event.where(is_actived: true).collect { |event| [event.event_name, event.id] }
        f.input :gender, as: :select, collection: ([['Male', true], ['Female', false]])
        f.input :origin, as: :string
        f.input :description
        f.input :warranty
        f.input :import_price, input_html: { value: number_with_precision(f.object.import_price, precision: 0) }
        f.input :sell_price, input_html: { value: number_with_precision(f.object.sell_price, precision: 0) }
        f.input :product_discount, label: 'Discount', input_html: { value: f.object.product_discount.nil? ? '' : f.object.product_discount.round(1) }
        f.input :shipping
        f.input :score_rating, input_html: { value: f.object.score_rating.nil? ? '' : f.object.score_rating.round(1) } unless f.object.new_record?
        f.input :number_of_rates unless f.object.new_record?
        f.input :is_available
        f.input :is_actived, label: 'Show?'
        f.br
        unless f.object.new_record?
          f.li do
            "#{f.label 'Comments'} #{f.a 'Edit comments', href: admin_product_comments_path(product_id: f.object.id)}".html_safe
          end
          f.li do
            "#{f.label 'Reviews'} #{f.a 'View reviews', href: admin_reviews_path(product_id: f.object.id)}".html_safe
          end
        end
        unless f.object.new_record?
          f.li "Created at: #{f.object.created_at}"
          f.li "Updated at: #{f.object.updated_at}"
          f.li do
            admin_user = AdminUser.find(f.object.created_by)
            "Created by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
          end
          f.li do
            admin_user = AdminUser.find(f.object.updated_by)
            "Updated by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
          end
        end
      end
      f.actions
    end
    batch_action :show, confirm: 'Are you sure you want to show these products?' do |ids|
      count = 0
      ids.each do |id|
        product = Product.find(id)
        count += 1 unless product.is_actived
        product.is_actived = true
        product.updated_at = Time.now
        product.updated_by = current_admin_user.id
        product.save(validate: false)
      end
      redirect_to collection_path, notice: "Successfully showed #{count} product#{count > 1 ? 's' : ''}"
    end
    batch_action :hide, confirm: 'Are you sure you want to hide these products?' do |ids|
      count = 0
      ids.each do |id|
        product = Product.find(id)
        count += 1 if product.is_actived
        product.is_actived = false
        product.updated_at = Time.now
        product.updated_by = current_admin_user.id
        product.save(validate: false)
      end
      redirect_to collection_path, notice: "Successfully hid #{count} product#{count > 1 ? 's' : ''}"
    end
    show do |product|
      attributes_table do
        row :product_name
        row 'image' do
          html = ''
          product.product_images.each do |product_image|
            html = "#{html} #{link_to(image_tag(product_image.image_url, width: '70px', height: '70px', class: 'border-img'), product_image.image_url, target: '_blank')}"
          end
          html.html_safe
        end
        row ' ' do
          link_to 'Edit product images', admin_product_images_path(product_id: product.id)
        end
        row :product_group do
          product_group = ProductGroup.find_by(id: product.product_group_id)
          link_to product_group.product_group_name, admin_product_group_path(product.product_group_id) unless product_group.nil?
        end
        row :supplier do
          supplier = Supplier.find_by(id: product.supplier_id)
          link_to supplier.supplier_name, admin_supplier_path(product.supplier_id) unless supplier.nil?
        end
        row :category do
          category = Category.find_by(id: product.category_id)
          link_to category.category_name, admin_category_path(product.category_id) unless category.nil?
        end
        row :age do
          age = Age.find_by(id: product.age_id)
          link_to age.age_name, admin_age_path(product.age_id) unless age.nil?
        end
        row :event do
          event = Event.find_by(id: product.event_id)
          link_to event.event_name, admin_event_path(product.event_id) unless event.nil?
        end
        row :gender do
          product.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no')
        end
        row :origin
        row :description
        row :warranty do
          "#{product.warranty} month#{product.warranty > 1 ? 's' : ''}"
        end
        row :import_price do
          number_to_currency(product.import_price, precision: 0, unit: ' VND', format: '%n %u')
        end
        row :sell_price do
          number_to_currency(product.sell_price, precision: 0, unit: ' VND', format: '%n %u')
        end
        row ' ' do
          link_to 'View Product Price Logs', admin_product_price_logs_path(product_id: product.id)
        end
        row 'Discount' do
          product.product_discount.round(1)
        end
        row :shipping do
          "#{product.shipping} day#{product.shipping > 1 ? 's' : ''}"
        end
        row :score_rating do
          product.score_rating.round(1)
        end
        row :number_of_rates
        row 'Comments' do
          link_to 'Edit comments', admin_product_comments_path(product_id: product.id)
        end
        row 'Reviews' do
          link_to 'View Reviews', admin_reviews_path(product_id: product.id)
        end
        row :is_available
        row 'Show' do
          product.is_actived ? status_tag('yes') : status_tag('no')
        end
        row :created_at
        row :updated_at
        row :created_by do
          admin_user = AdminUser.find(product.created_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
        row :updated_by do
          admin_user = AdminUser.find(product.updated_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
      end
    end
    after_create do |product|
      ProductPriceLog.create(
        admin_user_id: current_admin_user.id,
        product_id: product.id,
        import_price: product.import_price,
        sell_price: product.sell_price,
        updated_by: current_admin_user.id
      )
    end
    before_update do |product|
      product.gender = params[:product][:gender].eql?('true') ? true : false
      product.meta_title = product.product_name.parameterize
      product.updated_by = current_admin_user.id
    end
    after_update do |product|
      ProductPriceLog.create(
        admin_user_id: current_admin_user.id,
        product_id: product.id,
        import_price: product.import_price,
        sell_price: product.sell_price,
        updated_by: current_admin_user.id
      )
    end
    controller do
      def create
        if params[:product][:image].nil?
          redirect_to new_admin_product_path, alert: "Image can't be blank."
        else
          product = Product.create(
            event_id: params[:product][:event_id],
            supplier_id: params[:product][:supplier_id],
            product_group_id: params[:product][:product_group_id],
            category_id: params[:product][:category_id],
            age_id: params[:product][:age_id],
            product_name: params[:product][:product_name],
            meta_title: params[:product][:product_name].parameterize,
            origin: params[:product][:origin],
            description: params[:product][:description],
            gender: params[:product][:gender].eql?('true') ? true : false,
            warranty: params[:product][:warranty],
            import_price: params[:product][:import_price],
            sell_price: params[:product][:sell_price],
            product_discount: params[:product][:product_discount],
            shipping: params[:product][:shipping],
            score_rating: 0,
            number_of_rates: 0,
            is_available: params[:product][:is_available],
            is_actived: params[:product][:is_actived],
            created_by: current_admin_user.id,
            updated_by: current_admin_user.id
          )
          unless product.valid?
            return redirect_to new_admin_product_path, alert: "Product is invalid."
          end
          File.open(
            Rails.root.join(
              'public',
              'uploads',
              params[:product][:image].original_filename
            ),
            'wb'
          ) do |file|
            file.write(
              params[:product][:image].read
            )
          end
          image_url = "public/uploads/#{params[:product][:image].original_filename}"
          product_image_url = Cloudinary::Uploader.upload(image_url)['url']
          ProductImage.create(product_id: product.id, image_url: product_image_url, is_default: true, created_at: Time.now, created_by: current_admin_user.id)
          File.delete(image_url) if File.exist?(image_url)
          redirect_to resource_path(product.id), notice: 'Product was successfully created.'
        end
      end
      def edit
        @page_title = 'Hey, edit this product whose id is #' + resource.id
      end
    end
    
end