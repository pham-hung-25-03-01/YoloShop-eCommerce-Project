class CreateInventoryQuantityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_quantity_logs, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :inventory_id, null: false
      t.uuid :admin_id, null: false
      t.integer :quantity_of_import, null: false, default: 0
      t.integer :quantity_of_export, null: false, default: 0

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
