ActiveAdmin.register AdminUser do
  permit_params :first_name, :last_name, :avatar_url, :birthday, :phone_number, :email, :password, :password_confirmation, :permission, :avatar
  actions :all, except: [:destroy]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column 'Avatar', :avatar_url do |item|
      link_to(image_tag(item.avatar_url, width: '70px', height: '70px'), item.avatar_url) unless item.avatar_url.nil?
    end
    column(:birthday) { |time| time.birthday.strftime('%B %d, %Y') unless time.birthday.nil? }
    column :phone_number
    column :email
    column :permission
    column :created_at
    column :updated_at
    column :updated_by
    actions
  end
  filter :id_eq, label: 'id'
  filter :first_name
  filter :last_name
  filter :birthday
  filter :phone_number
  filter :email
  filter :permission, as: :numeric
  filter :created_at
  filter :updated_at
  filter :updated_by_eq, label: 'updated by'

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :first_name, as: :string
      f.input :last_name, as: :string
      f.input :avatar, as: :file
      f.input :birthday, as: :datepicker, input_html: { value: f.object.birthday.try(:strftime, '%Y-%m-%d') }
      f.input :phone_number, input_html: { maxlength: 10, oninput: "this.value = this.value.replace(/[^0-9]/g, '').replace(/(\\..*?)\\..*/g, '$1');" }
      if f.object.new_record?
        f.input :email
      else
        f.input :email, input_html: { readonly: true, disabled: true }
      end
      f.input :password
      f.input :password_confirmation
      f.input :permission
      unless f.object.new_record?
        f.li "Created at: #{f.object.created_at}"
        f.li "Updated at: #{f.object.updated_at}"
        f.li do
          admin_user = AdminUser.find(f.object.updated_by)
          "Updated by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
        end
      end
    end
    f.actions
  end
  show do |admin_user|
    attributes_table do
        row :first_name
        row :last_name
        row :avatar_url do
            link_to admin_user.avatar_url, admin_user.avatar_url, target: '_blank' unless admin_user.avatar_url.nil?
        end
        row :birthday
        row :phone_number do
            link_to admin_user.phone_number, "tel:#{admin_user.phone_number}"
        end
        row :email do
            link_to admin_user.email, "mailto:#{admin_user.email}"
        end
        row :permission
        row :created_at
        row :updated_at
        row :updated_by do
          admin_user_update = AdminUser.find(admin_user.updated_by)
          link_to admin_user_update.email, admin_admin_user_path(admin_user_update.id)
        end
    end
  end
  before_create do |admin_user|
    admin_user.updated_by = current_admin_user.id
  end
  before_update do |admin_user|
    admin_user.updated_by = current_admin_user.id
  end
  controller do
    def create
      unless params[:admin_user][:avatar].nil?
        File.open(
          Rails.root.join(
            'public',
            'uploads',
            params[:admin_user][:avatar].original_filename
          ),
          'wb'
        ) do |file|
          file.write(
            params[:admin_user][:avatar].read
          )
        end
        image_url = "public/uploads/#{params[:admin_user][:avatar].original_filename}"
        @admin_user.avatar_url = Cloudinary::Uploader.upload(image_url)['url']
        File.delete(image_url) if File.exist?(image_url)
      end
      params[:admin_user].reject! { |p| p['avatar'] }
      super
    end

    def update
      params[:admin_user].reject! { |p| p['email'] }
      @admin_user = AdminUser.find(
        params[:id]
      )
      unless @admin_user.avatar_url.nil?
        public_id = @admin_user.avatar_url.split('/')[-1].split('.')[0]
        Cloudinary::Uploader.destroy(public_id)
        @admin_user.avatar_url = nil
      end
      unless params[:admin_user][:avatar].nil?
        File.open(
          Rails.root.join(
            'public',
            'uploads',
            params[:admin_user][:avatar].original_filename
          ),
          'wb'
        ) do |file|
          file.write(
            params[:admin_user][:avatar].read
          )
        end
        image_url = "public/uploads/#{params[:admin_user][:avatar].original_filename}"
        @admin_user.avatar_url = Cloudinary::Uploader.upload(image_url)['url']
        File.delete(image_url) if File.exist?(image_url)
      end
      params[:admin_user].reject! { |p| p['avatar'] }
      super
    end
    def edit
      @page_title = 'Hey, edit this admin user whose id is #' + resource.id
    end
  end

end
