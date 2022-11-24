ActiveAdmin.register Banner do
    permit_params :event_id, :banner
    actions :all, except: [:update, :edit]
  
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
    batch_action :destroy, confirm: 'Are you sure you want to delete these banners?' do |ids|
      ids.each do |id|
        banner = Banner.find(id)
        public_id = banner.banner_url.split('/')[-1].split('.')[0]
        Cloudinary::Uploader.destroy(public_id)
        banner.destroy
      end
      redirect_to collection_path, notice: "Successfully deleted #{ids.count} banner#{ids.count > 1 ? 's' : ''}"
    end
    show do |banner|
      attributes_table do
        row :event do
          link_to banner.event.event_name, admin_event_path(banner.event.id) unless banner.event_id.nil?
        end
        row :banner_url do
          link_to banner.banner_url, banner.banner_url, target: '_blank'
        end
        row :created_at
        row 'created by' do
          link_to banner.admin_user.email, admin_admin_user_path(banner.admin_user.id)
        end
      end
    end
    controller do
      def create
        unless params[:banner][:banner].nil?
          File.open(
            Rails.root.join(
              'public',
              'uploads',
              params[:banner][:banner].original_filename
            ),
            'wb'
          ) do |file|
            file.write(
              params[:banner][:banner].read
            )
          end
          image_url = "public/uploads/#{params[:banner][:banner].original_filename}"
          banner_url = Cloudinary::Uploader.upload(image_url)['url']
          File.delete(image_url) if File.exist?(image_url)
        end
        banner = Banner.create(
          event_id: params[:banner][:event_id],
          banner_url: banner_url,
          created_at: Time.now,
          admin_user_id: current_admin_user.id
        )
        if banner.valid?
          redirect_to resource_path(banner.id), notice: 'Banner was successfully created.'
        else
          redirect_to new_admin_banner_path, alert: "Banner can't be blank."
        end
      end
      def destroy
        banner = Banner.find(
          params[:id]
        )
        public_id = banner.banner_url.split('/')[-1].split('.')[0]
        Cloudinary::Uploader.destroy(public_id)
        super
      end
    end
    
end