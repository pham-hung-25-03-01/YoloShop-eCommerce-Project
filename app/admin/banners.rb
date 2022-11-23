ActiveAdmin.register Banner do
    permit_params :event_id, :banner
  
    index do
      selectable_column
      id_column
      column :event_id
      column 'Banner', :banner_url do |item|
        link_to(image_tag(item.banner_url, width: '70px', height: '70px'), item.banner_url)
      end
      column :created_at
      column 'Created By', :admin_user_id
      actions
    end
    filter :event_id_eq, label: 'event id'
    filter :created_at
    filter :admin_user_id_eq, label: 'created by'
  
    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :event, as: :select, collection: Event.where(is_actived: true).collect { |event| [event.event_name, event.id] }
        f.input :banner, as: :file
        unless f.object.new_record?
          f.li "Created at: #{f.object.created_at}"
          f.li "Created by: #{f.object.admin_user_id}"
        end
      end
      f.actions
    end
    # batch_action :destroy, confirm: 'Are you sure you want to delete these ages?' do |ids|
    #   ids.each do |id|
    #     Age.update(
    #       id,
    #       is_actived: false,
    #       deleted_at: Time.now,
    #       deleted_by: current_admin_user.id
    #     )
    #     Product.where(
    #       age_id: id
    #     ).update_all(
    #       age_id: nil
    #     )
    #   end
    #   redirect_to collection_path
    # end
    # show do |age|
    #   attributes_table do
    #     row :age_name
    #     row :created_at
    #     row :updated_at
    #     row :created_by
    #     row :updated_by
    #   end
    # end
    # before_create do |age|
    #   age.created_at = Time.now
    #   age.updated_at = Time.now
    #   age.created_by = current_admin_user.id
    #   age.updated_by = current_admin_user.id
    # end
    # controller do
    #   def scoped_collection
    #     super.where(is_actived: true)
    #   end
    #   def create
    #     age_inactive = Age.find_by(
    #       age_name: params[:age][:age_name],
    #       is_actived: false
    #     )
    #     if age_inactive.nil?
    #       super
    #     else
    #       age_inactive.update(
    #         is_actived: true
    #       )
    #       redirect_to resource_path(age_inactive.id), notice: 'Age was successfully created.'
    #     end
    #   end
    #   def destroy
    #     Age.update(
    #       params[:id],
    #       is_actived: false,
    #       deleted_at: Time.now,
    #       deleted_by: current_admin_user.id
    #     )
    #     Product.where(
    #       age_id: params[:id]
    #     ).update_all(
    #       age_id: nil
    #     )
    #     redirect_to admin_ages_path
    #   end
    #   def edit
    #     @page_title = 'Hey, edit this age whose id is #' + resource.id
    #   end
    # end
    
end