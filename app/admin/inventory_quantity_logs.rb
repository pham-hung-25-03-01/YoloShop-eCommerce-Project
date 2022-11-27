ActiveAdmin.register InventoryQuantityLog do
    menu false
    permit_params :quantity_of_import, :quantity_of_export
    actions :all, except: [:show, :update, :edit]

    index do
        selectable_column
        id_column
        column :inventory_id
        column :quantity_of_import
        column :quantity_of_export
        column :created_at
        column :updated_at
        column 'Created by' do |item|
            item.admin_user_id
        end
        column :updated_by
        actions
    end
    
    filter :id_eq, label: 'id'
    filter :inventory_id_eq, label: 'inventory id'
    filter :quantity_of_import, as: :numeric
    filter :quantity_of_export, as: :numeric
    filter :created_at
    filter :updated_at
    filter :admin_user_id_eq, label: 'created by'
    filter :updated_by_eq, label: 'updated by'

    form do |f|
        f.semantic_errors
        f.inputs do
          f.input :quantity_of_import
          f.input :quantity_of_export
        end
        f.actions do
            f.action :submit
            f.cancel_link(admin_inventory_quantity_logs_path(inventory_id: session[:inventory_id]))
        end
    end
    batch_action :destroy, false
    # batch_action :destroy, confirm: 'Are you sure you want to delete these inventory quantity logs?' do |ids|
    #     ids.each do |id|
    #         inventory_quantity_log = InventoryQuantityLog.update(
    #             id,
    #             is_actived: false,
    #             deleted_at: Time.now,
    #             deleted_by: current_admin_user.id
    #         )
    #         inventory = Inventory.find(inventory_quantity_log.inventory_id)
    #         inventory.quantity_of_inventory += (inventory_quantity_log.quantity_of_export - inventory_quantity_log.quantity_of_import)
    #         inventory.save
    #     end
    #     redirect_to admin_inventory_quantity_logs_path(inventory_id: session[:inventory_id]), notice: "Successfully deleted #{ids.count} inventory quantity log#{ids.count > 1 ? 's' : ''}"
    # end
    controller do
        def scoped_collection
            if params[:inventory_id].nil?
                super.where(is_actived: true)
            else
                super.where(inventory_id: params[:inventory_id], is_actived: true)
            end
        end
        def index
            session[:inventory_id] = params[:inventory_id]
            @page_title = "Manage For Inventory ##{params[:inventory_id]}"
            super
        end
        def create
            inventory = Inventory.find(session[:inventory_id])
            return redirect_to new_admin_inventory_quantity_log_path, alert: 'Quantity is invalid.' if params[:inventory_quantity_log][:quantity_of_import].to_i - params[:inventory_quantity_log][:quantity_of_export].to_i + inventory.quantity_of_inventory < 0
            inventory_quantity_log = InventoryQuantityLog.create(
                inventory_id: session[:inventory_id],
                admin_user_id: current_admin_user.id,
                quantity_of_import: params[:inventory_quantity_log][:quantity_of_import],
                quantity_of_export: params[:inventory_quantity_log][:quantity_of_export],
                updated_by: current_admin_user.id
            )
            inventory.quantity_of_inventory += (inventory_quantity_log.quantity_of_import - inventory_quantity_log.quantity_of_export)
            inventory.save
            redirect_to admin_inventory_quantity_logs_path(inventory_id: inventory.id), notice: 'Inventory quantity log was successfully created.'
        end
        def destroy
            inventory = Inventory.find(session[:inventory_id])
            inventory_quantity_log = InventoryQuantityLog.find(params[:id])
            return redirect_to admin_inventory_quantity_logs_path(inventory_id: inventory.id), alert: 'Quantity is invalid.' if inventory_quantity_log.quantity_of_export - inventory_quantity_log.quantity_of_import + inventory.quantity_of_inventory < 0
            inventory_quantity_log.is_actived = false
            inventory_quantity_log.deleted_at = Time.now
            inventory_quantity_log.deleted_by = current_admin_user.id
            inventory_quantity_log.save
            inventory.quantity_of_inventory += (inventory_quantity_log.quantity_of_export - inventory_quantity_log.quantity_of_import)
            inventory.save
            redirect_to admin_inventory_quantity_logs_path(inventory_id: inventory.id), notice: 'Inventory quantity log was successfully deleted.'
        end
    end
end