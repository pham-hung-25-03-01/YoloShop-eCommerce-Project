ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :avatar_url, :birthday, :phone_number, :email, :password, :password_confirmation, :permission

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :birthday
    column :phone_number
    column :email
    column :permission
    column :created_at
    column :updated_at
    column :updated_by
    actions
  end
  filter :first_name
  filter :last_name
  filter :birthday
  filter :phone_number
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :permission
  filter :created_at
  filter :updated_at
  filter :updated_by

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :birthday
      f.input :phone_number
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :permission
    end
    f.actions
  end

end
