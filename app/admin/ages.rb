ActiveAdmin.register Age do
  permit_params :age_name

  index do
    selectable_column
    id_column
    column :age_name
    column :created_at
    column :updated_at
    column :created_by
    column :updated_by
    actions
  end
  filter :age_name
  filter :created_at
  filter :updated_at
  filter :created_by_eq, label: 'created by'
  filter :updated_by_eq, label: 'updated by'

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :age_name, as: :string
      unless f.object.new_record?
        f.li "Created at: #{f.object.created_at}"
        f.li "Updated at: #{f.object.updated_at}"
        f.li "Created by: #{f.object.created_by}"
        f.li "Updated by: #{f.object.updated_by}"
      end
    end
    f.actions
  end
  batch_action :destroy, confirm: 'Are you sure you want to delete these ages?' do |ids|
    ids.each do |id|
      Age.update(
        id,
        is_actived: false,
        deleted_at: Time.now,
        deleted_by: current_admin_user.id
      )
      Product.where(
        age_id: id
      ).update_all(
        age_id: nil
      )
    end
    redirect_to collection_path, notice: "Successfully deleted #{ids.count} age#{ids.count > 1 ? 's' : ''}"
  end
  show do |age|
    attributes_table do
      row :age_name
      row :created_at
      row :updated_at
      row :created_by
      row :updated_by
    end
  end
  before_create do |age|
    age.created_at = Time.now
    age.updated_at = Time.now
    age.created_by = current_admin_user.id
    age.updated_by = current_admin_user.id
  end
  controller do
    def scoped_collection
      super.where(is_actived: true)
    end
    def create
      age_inactive = Age.find_by(
        age_name: params[:age][:age_name],
        is_actived: false
      )
      if age_inactive.nil?
        super
      else
        age_inactive.update(
          is_actived: true
        )
        redirect_to resource_path(age_inactive.id), notice: 'Age was successfully created.'
      end
    end
    def destroy
      Age.update(
        params[:id],
        is_actived: false,
        deleted_at: Time.now,
        deleted_by: current_admin_user.id
      )
      Product.where(
        age_id: params[:id]
      ).update_all(
        age_id: nil
      )
      redirect_to admin_ages_path
    end
    def edit
      @page_title = 'Hey, edit this age whose id is #' + resource.id
    end
  end
  
end