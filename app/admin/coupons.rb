ActiveAdmin.register Coupon do
    permit_params :id, :start_date, :end_date, :coupon_discount, :number_of_uses
    index do
        selectable_column
        id_column
        column :start_date
        column :end_date
        column 'Discount' do |item|
            item.coupon_discount.round(1)
        end
        column :number_of_uses
        column :created_at
        column :updated_at
        column :created_by
        column :updated_by
        actions
    end
    filter :id_eq, label: 'id'
    filter :start_date
    filter :end_date
    filter :coupon_discount
    filter :number_of_uses
    filter :created_at
    filter :updated_at
    filter :created_by_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'

    form do |f|
        f.semantic_errors
        f.inputs do
          f.input :id if f.object.new_record?
          f.input :start_date, as: :datepicker, input_html: { value: f.object.start_date.try(:strftime, '%Y-%m-%d') }
          f.input :end_date, as: :datepicker, input_html: { value: f.object.end_date.try(:strftime, '%Y-%m-%d') }
          f.input :coupon_discount, label: 'Discount'
          f.input :number_of_uses
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
    
    show do |coupon|
        attributes_table do
          row :start_date
          row :end_date
          row 'Discount' do
            coupon.coupon_discount.round(1)
          end
          row :number_of_uses
          row :created_at
          row :updated_at
          row :created_by do
            admin_user = AdminUser.find(coupon.created_by)
            link_to admin_user.email, admin_admin_user_path(admin_user.id)
          end
          row :updated_by do
            admin_user = AdminUser.find(coupon.updated_by)
            link_to admin_user.email, admin_admin_user_path(admin_user.id)
          end
        end
    end
    batch_action :destroy, confirm: 'Are you sure you want to delete these coupons?' do |ids|
        ids.each do |id|
            Coupon.update(
                id,
                is_actived: false,
                deleted_at: Time.now,
                deleted_by: current_admin_user.id
            )
            Order.where(
                coupon_id: id
            ).update_all(
                coupon_id: nil
            )
        end
        redirect_to collection_path, notice: "Successfully deleted #{ids.count} coupon#{ids.count > 1 ? 's' : ''}"
    end
    before_create do |coupon|
        coupon.id = coupon.id.strip
        coupon.created_by = current_admin_user.id
        coupon.updated_by = current_admin_user.id
    end
    before_update do |coupon|
        coupon.updated_by = current_admin_user.id
    end
    controller do
        def scoped_collection
            super.where(is_actived: true)
        end
        def create
            coupon_inactive = Coupon.find_by(
              id: params[:coupon][:id],
              is_actived: false
            )
            if coupon_inactive.nil?
              super
            else
              coupon_inactive.update(
                start_date: params[:coupon][:start_date],
                end_date: params[:coupon][:end_date],
                coupon_discount: params[:coupon][:coupon_discount],
                number_of_uses: params[:coupon][:number_of_uses],
                created_by: current_admin_user.id,
                updated_by: current_admin_user.id,
                created_at: Time.now,
                is_actived: true,
                deleted_at: nil,
                deleted_by: nil
              )
              return redirect_to new_admin_coupon_path(), alert: 'Coupon is invalid.' unless coupon_inactive.valid?
              redirect_to resource_path(coupon_inactive.id), notice: 'Coupon was successfully created.'
            end
          end
        def destroy
            Coupon.update(
                params[:id],
                is_actived: false,
                deleted_at: Time.now,
                deleted_by: current_admin_user.id
            )
            Order.where(
                coupon_id: params[:id]
            ).update_all(
                coupon_id: nil
            )
            redirect_to admin_coupons_path, notice: 'Coupon was successfully deleted.'
        end
        def edit
          @page_title = 'Hey, edit this coupon whose id is #' + resource.id
        end
    end
end