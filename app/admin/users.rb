ActiveAdmin.register User do
    permit_params :first_name, :last_name, :gender, :birthday, :phone_number, :apartment_number, :street, :ward, :district, :province, :email, :password, :password_confirmation, :avatar
    actions :all, except: [:new, :create, :destroy]
  
    index do
      selectable_column
      id_column
      column :first_name
      column :last_name
      column 'Avatar', :avatar_url do |item|
        link_to(image_tag(item.avatar_url, width: '70px', height: '70px'), item.avatar_url) unless item.avatar_url.nil?
      end
      column :gender do |item|
        item.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no')
      end
      column(:birthday) { |time| time.birthday.strftime('%B %d, %Y') unless time.birthday.nil? }
      column :phone_number
      column :email
      column 'Adress' do |item|
        item.province
      end
      column :created_at
      column :updated_at
      actions
    end
    filter :id_eq, label: 'id'
    filter :first_name
    filter :last_name
    filter :gender, as: :select, collection: -> { [['Male', true], ['Female', false]] }
    filter :birthday
    filter :phone_number
    filter :email
    filter :province, label: 'address'
    filter :created_at
    filter :updated_at
  
    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :first_name, as: :string
        f.input :last_name, as: :string
        f.input :avatar, as: :file
        f.input :gender, as: :select, collection: ([['Male', true], ['Female', false]])
        f.input :birthday, as: :datepicker, input_html: { value: f.object.birthday.try(:strftime, '%Y-%m-%d') }
        f.input :phone_number, input_html: { maxlength: 10, oninput: "this.value = this.value.replace(/[^0-9]/g, '').replace(/(\\..*?)\\..*/g, '$1');" }
        f.input :apartment_number, as: :string
        f.input :street, as: :string
        f.input :ward, as: :string
        f.input :district, as: :string
        f.input :province, as: :string
        f.input :email, input_html: { readonly: true, disabled: true }
        f.input :provider, input_html: { readonly: true, disabled: true }
        f.input :password
        f.input :password_confirmation
        unless f.object.new_record?
          f.li "Created at: #{f.object.created_at}"
          f.li "Updated at: #{f.object.updated_at}"
          f.li do
            admin_user = AdminUser.find_by(id: f.object.updated_by)
            if admin_user.nil?
                user = User.find(f.object.updated_by)
                "Updated by: #{link_to user.email, admin_user_path(user.id)}".html_safe
            else
                "Updated by: #{link_to admin_user.email, admin_admin_user_path(admin_user.id)}".html_safe
            end
          end
        end
      end
      f.actions
    end
    show do |user|
        attributes_table do
            row :first_name
            row :last_name
            row :avatar_url do
                link_to user.avatar_url, user.avatar_url, target: '_blank' unless user.avatar_url.nil?
            end
            row :gender do
                user.gender ? status_tag('Male', class: 'yes') : status_tag('Female', class: 'no')
            end
            row :birthday
            row :phone_number do
                link_to user.phone_number, "tel:#{user.phone_number}"
            end
            row :apartment_number
            row :street
            row :ward
            row :district
            row :province
            row :provider
            row :uid
            row :email do
                link_to user.email, "mailto:#{user.email}"
            end
            row :created_at
            row :updated_at
            row :updated_by do
                admin_user = AdminUser.find_by(id: user.updated_by)
                if admin_user.nil?
                    user = User.find(user.updated_by)
                    link_to user.email, admin_user_path(user.id)
                else
                    link_to admin_user.email, admin_admin_user_path(admin_user.id)
                end
            end
        end
    end
    before_update do |user|
        user.updated_by = current_admin_user.id
    end
    controller do
      def update
        params[:user].reject! { |p| p['email'] }
        @user = User.find(
          params[:id]
        )
        unless @user.avatar_url.nil?
          public_id = @user.avatar_url.split('/')[-1].split('.')[0]
          Cloudinary::Uploader.destroy(public_id)
          @user.avatar_url = nil
        end
        unless params[:user][:avatar].nil?
          File.open(
            Rails.root.join(
              'public',
              'uploads',
              params[:user][:avatar].original_filename
            ),
            'wb'
          ) do |file|
            file.write(
              params[:user][:avatar].read
            )
          end
          image_url = "public/uploads/#{params[:user][:avatar].original_filename}"
          @user.avatar_url = Cloudinary::Uploader.upload(image_url)['url']
          File.delete(image_url) if File.exist?(image_url)
        end
        params[:user].reject! { |p| p['avatar'] }
        super
      end
      def edit
        @page_title = 'Hey, edit this user whose id is #' + resource.id
      end
    end
  
  end
  