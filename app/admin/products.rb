ActiveAdmin.register Product do
    remove_filter :reviews
    permit_params :event_id, :supplier_id, :product_group_id, :category_id, :age_id, :product_name, :origin, :description,
    :gender, :warranty, :import_price, :sell_price, :product_discount, :shipping, :score_rating, :number_of_rates, :is_available
  
    index do
      selectable_column
      id_column
      column :product_group_name
      column :supplier_id
      column :category_id
      column :age_id
      column :origin
      column :gender
      column :warranty
      column :import_price
      column :sell_price
      column :product_discount
      column :score_rating
      actions
    end
    # filter :supplier_name
    # filter :contract_date
    # filter :phone_number
    # filter :email
    # filter :address
    # filter :is_cooperated
  
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
    # show do |supplier|
    #   attributes_table do
    #     row :id
    #     row :supplier_name
    #     row :contract_date
    #     row :phone_number
    #     row :email
    #     row :address
    #     row :is_cooperated
    #     row :created_at
    #     row :updated_at
    #     row :created_by do
    #       admin_user = AdminUser.find(supplier.created_by)
    #       link_to admin_user.email, admin_admin_user_path(admin_user.id)
    #     end
    #     row :updated_by do
    #       admin_user = AdminUser.find(supplier.updated_by)
    #       link_to admin_user.email, admin_admin_user_path(admin_user.id)
    #     end
    #   end
    # end
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