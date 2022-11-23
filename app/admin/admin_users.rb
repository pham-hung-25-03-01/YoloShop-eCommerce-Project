ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :avatar_url, :birthday, :phone_number, :password, :password_confirmation, :permission, :avatar

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :avatar_url
    column (:birthday) { |time| time.birthday.strftime('%B %d, %Y') }
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
  filter :permission
  filter :created_at
  filter :updated_at
  filter :updated_by

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :first_name, as: :string
      f.input :last_name, as: :string
      f.input :avatar, as: :file
      f.input :birthday, as: :datepicker, input_html: { value: f.object.birthday.try(:strftime, '%Y-%m-%d') }
      f.input :phone_number, input_html: { maxlength: 10, oninput: "this.value = this.value.replace(/[^0-9]/g, '').replace(/(\\..*?)\\..*/g, '$1');" }
      f.input :email, input_html: { readonly: true, disabled: true}
      f.input :password
      f.input :password_confirmation
      f.input :permission
      unless f.object.new_record?
        f.li "Created at #{f.object.created_at}"
        f.li "Created at #{f.object.created_at}"
        f.li "Created at #{f.object.created_at}"
      end
    end
    f.actions
  end

  controller do
    def create
    end

    def update
      @admin_user = AdminUser.find(params[:id])
      @admin_user.avatar_url = params[:admin_user][:avatar].original_filename
      params[:admin_user].reject! { |p| p['avatar'] }
      super
    end
  end

end
