ActiveAdmin.register Product do
    permit_params :event_id, :supplier_id, :product_group_id, :category_id, :age_id, :product_name, :origin, :description,
    :gender, :warranty, :import_price, :sell_price, :product_discount, :shipping, :score_rating, :number_of_rates, :is_available
  
    index do
      selectable_column
      id_column
      column :product_name
      column 'Image' do |item|
        unless item.product_images.nil?
          image_url = item.product_images.find_by(is_default: true).image_url
          link_to(image_tag(image_url, width: '70px', height: '70px'), image_url, target: '_blank')
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
        item.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no')
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
      actions
    end
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
  
    # form do |f|
    #   f.semantic_errors
    #   f.inputs do
    #     f.input :supplier_name, as: :string
    #     f.input :contract_date, as: :datepicker, input_html: { value: f.object.contract_date.try(:strftime, '%Y-%m-%d') }
    #     f.input :phone_number, input_html: { maxlength: 10, oninput: "this.value = this.value.replace(/[^0-9]/g, '').replace(/(\\..*?)\\..*/g, '$1');" }
    #     f.input :email
    #     f.input :address
    #     f.input :is_cooperated
    #     f.br
    #     unless f.object.new_record?
    #       f.li "Created at: #{f.object.created_at}"
    #       f.li "Updated at: #{f.object.updated_at}"
    #       f.li do
    #         admin_user = AdminUser.find(f.object.created_by)
    #         "Created by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
    #       end
    #       f.li do
    #         admin_user = AdminUser.find(f.object.updated_by)
    #         "Updated by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
    #       end
    #     end
    #   end
    #   f.actions
    # end
    # batch_action :destroy, confirm: 'Are you sure you want to delete these suppliers?' do |ids|
    #   ids.each do |id|
    #     Supplier.update(
    #       id,
    #       is_actived: false,
    #       deleted_at: Time.now,
    #       deleted_by: current_admin_user.id
    #     )
    #     Product.where(
    #       supplier_id: id
    #     ).update_all(
    #       supplier_id: nil
    #     )
    #   end
    #   redirect_to collection_path, notice: "Successfully deleted #{ids.count} supplier#{ids.count > 1 ? 's' : ''}"
    # end
    show do |product|
      attributes_table do
        row :product_name
        #row :product_images
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
          link_to event.event_name, admin_age_path(product.event_id) unless event.nil?
        end
        row :gender do
          product.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no')
        end
        row :origin
        row :description
        row :warranty
        
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
    # before_create do |supplier|
    #   supplier.created_by = current_admin_user.id
    #   supplier.updated_by = current_admin_user.id
    # end
    # before_update do |supplier|
    #   supplier.updated_by = current_admin_user.id
    # end
    # controller do
    #   def scoped_collection
    #     super.where(is_actived: true)
    #   end
    #   def create
    #     supplier_inactive = Supplier.find_by(
    #       supplier_name: params[:supplier][:supplier_name],
    #       is_actived: false
    #     )
    #     if supplier_inactive.nil?
    #       super
    #     else
    #       supplier_inactive.update(
    #         contract_date: params[:supplier][:contract_date],
    #         phone_number: params[:supplier][:phone_number],
    #         email: params[:supplier][:email],
    #         address: params[:supplier][:address],
    #         is_cooperated: params[:supplier][:is_cooperated],
    #         created_by: current_admin_user.id,
    #         updated_by: current_admin_user.id,
    #         created_at: Time.now,
    #         is_actived: true,
    #         deleted_at: nil,
    #         deleted_by: nil
    #       )
    #       if supplier_inactive.valid?
    #         redirect_to resource_path(supplier_inactive.id), notice: 'Supplier was successfully created.'
    #       else
    #         redirect_to new_admin_supplier_path, alert: "Supplier is invalid."
    #       end
    #     end
    #   end
    #   def destroy
    #     Supplier.update(
    #       params[:id],
    #       is_actived: false,
    #       deleted_at: Time.now,
    #       deleted_by: current_admin_user.id
    #     )
    #     Product.where(
    #       supplier_id: params[:id]
    #     ).update_all(
    #       supplier_id: nil
    #     )
    #     redirect_to admin_suppliers_path
    #   end
    #   def edit
    #     @page_title = 'Hey, edit this supplier whose id is #' + resource.id
    #   end
    # end
    
end