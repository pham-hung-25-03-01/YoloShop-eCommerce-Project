ActiveAdmin.register ProductGroup do
    permit_params :product_group_name
  
    index do
      selectable_column
      id_column
      column :product_group_name
      column :created_at
      column :updated_at
      column :created_by
      column :updated_by
      actions
    end
    filter :id_eq, label: 'id'
    filter :product_group_name
    filter :created_at
    filter :updated_at
    filter :created_by_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'
  
    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :product_group_name, as: :string
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
    batch_action :destroy, confirm: 'Are you sure you want to delete these product groups?' do |ids|
      ids.each do |id|
        ProductGroup.update(
          id,
          is_actived: false,
          deleted_at: Time.now,
          deleted_by: current_admin_user.id
        )
        Product.where(
          product_group_id: id
        ).update_all(
          product_group_id: nil
        )
      end
      redirect_to collection_path, notice: "Successfully deleted #{ids.count} product group#{ids.count > 1 ? 's' : ''}"
    end
    show do |product_group|
      attributes_table do
        row :product_group_name
        row :created_at
        row :updated_at
        row :created_by do
          admin_user = AdminUser.find(product_group.created_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
        row :updated_by do
          admin_user = AdminUser.find(product_group.updated_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
      end
    end
    before_create do |product_group|
      product_group.created_by = current_admin_user.id
      product_group.updated_by = current_admin_user.id
    end
    before_update do |product_group|
      product_group.updated_by = current_admin_user.id
    end
    controller do
      def scoped_collection
        super.where(is_actived: true)
      end
      def create
        product_group_inactive = ProductGroup.find_by(
          product_group_name: params[:product_group][:product_group_name],
          is_actived: false
        )
        if product_group_inactive.nil?
          super
        else
          product_group_inactive.update(
            created_by: current_admin_user.id,
            updated_by: current_admin_user.id,
            created_at: Time.now,
            is_actived: true,
            deleted_at: nil,
            deleted_by: nil
          )
          redirect_to resource_path(product_group_inactive.id), notice: 'Product group was successfully created.'
        end
      end
      def destroy
        ProductGroup.update(
          params[:id],
          is_actived: false,
          deleted_at: Time.now,
          deleted_by: current_admin_user.id
        )
        Product.where(
          product_group_id: params[:id]
        ).update_all(
          product_group_id: nil
        )
        redirect_to admin_product_groups_path, notice: 'Product group was successfully deleted.'
      end
      def edit
        @page_title = 'Hey, edit this product group whose id is #' + resource.id
      end
    end
    
end