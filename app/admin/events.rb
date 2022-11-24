ActiveAdmin.register Event do
  permit_params :event_name

  index do
    selectable_column
    id_column
    column :event_name
    column :created_at
    column :updated_at
    column :created_by
    column :updated_by
    actions
  end
  filter :event_name
  filter :created_at
  filter :updated_at
  filter :created_by_eq, label: 'created by'
  filter :updated_by_eq, label: 'updated by'

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :event_name, as: :string
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
  batch_action :destroy, confirm: 'Are you sure you want to delete these events?' do |ids|
    ids.each do |id|
      Event.update(
        id,
        is_actived: false,
        deleted_at: Time.now,
        deleted_by: current_admin_user.id
      )
      Product.where(
        event_id: id
      ).update_all(
        event_id: nil
      )
      Banner.where(
        event_id: id
      ).update_all(
        event_id: nil
      )
    end
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} event#{ids.count > 1 ? 's' : ''}"
  end
  show do |event|
    attributes_table do
      row :event_name
      row :created_at
      row :updated_at
      row :created_by do
        admin_user = AdminUser.find(event.created_by)
        link_to admin_user.email, admin_admin_user_path(admin_user.id)
      end
      row :updated_by do
        admin_user = AdminUser.find(event.updated_by)
        link_to admin_user.email, admin_admin_user_path(admin_user.id)
      end
    end
  end
  before_create do |event|
    event.created_by = current_admin_user.id
    event.updated_by = current_admin_user.id
  end
  before_update do |event|
    event.updated_by = current_admin_user.id
  end
  controller do
    def scoped_collection
      super.where(is_actived: true)
    end
    def create
      event_inactive = Event.find_by(
        event_name: params[:event][:event_name],
        is_actived: false
      )
      if event_inactive.nil?
        super
      else
        event_inactive.update(
          created_by: current_admin_user.id,
          updated_by: current_admin_user.id,
          created_at: Time.now,
          is_actived: true,
          deleted_at: nil,
          deleted_by: nil
        )
        redirect_to resource_path(event_inactive.id), notice: 'Event was successfully created.'
      end
    end
    def destroy
      Event.update(
        params[:id],
        is_actived: false,
        deleted_at: Time.now,
        deleted_by: current_admin_user.id
      )
      Product.where(
        event_id: params[:id]
      ).update_all(
        event_id: nil
      )
      Banner.where(
        event_id: params[:id]
      ).update_all(
        event_id: nil
      )
      redirect_to admin_events_path
    end
    def edit
      @page_title = 'Hey, edit this event whose id is #' + resource.id
    end
  end

end