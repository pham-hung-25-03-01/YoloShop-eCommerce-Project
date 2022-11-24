ActiveAdmin.register Category do
    permit_params :category_name
  
    index do
      selectable_column
      id_column
      column :category_name
      column :created_at
      column :updated_at
      column :created_by
      column :updated_by
      actions
    end
    filter :category_name
    filter :created_at
    filter :updated_at
    filter :created_by_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'
  
    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :category_name, as: :string
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
    batch_action :destroy, confirm: 'Are you sure you want to delete these categories?' do |ids|
      ids.each do |id|
        Category.update(
          id,
          is_actived: false,
          deleted_at: Time.now,
          deleted_by: current_admin_user.id
        )
        Product.where(
          category_id: id
        ).update_all(
          category_id: nil
        )
      end
      redirect_to collection_path, notice: "Successfully deleted #{ids.count} #{ids.count > 1 ? 'categories' : 'category'}"
    end
    show do |category|
      attributes_table do
        row :category_name
        row :created_at
        row :updated_at
        row :created_by do
          admin_user = AdminUser.find(category.created_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
        row :updated_by do
          admin_user = AdminUser.find(category.updated_by)
          link_to admin_user.email, admin_admin_user_path(admin_user.id)
        end
      end
    end
    before_create do |category|
      category.created_by = current_admin_user.id
      category.updated_by = current_admin_user.id
    end
    before_update do |category|
      category.updated_by = current_admin_user.id
    end
    controller do
      def scoped_collection
        super.where(is_actived: true)
      end
      def create
        category_inactive = Category.find_by(
          category_name: params[:category][:category_name],
          is_actived: false
        )
        if category_inactive.nil?
          super
        else
          category_inactive.update(
            created_by: current_admin_user.id,
            updated_by: current_admin_user.id,
            created_at: Time.now,
            is_actived: true,
            deleted_at: nil,
            deleted_by: nil
          )
          redirect_to resource_path(category_inactive.id), notice: 'Category was successfully created.'
        end
      end
      def destroy
        Category.update(
          params[:id],
          is_actived: false,
          deleted_at: Time.now,
          deleted_by: current_admin_user.id
        )
        Product.where(
          category_id: params[:id]
        ).update_all(
          category_id: nil
        )
        redirect_to admin_categories_path
      end
      def edit
        @page_title = 'Hey, edit this category whose id is #' + resource.id
      end
    end
    
end