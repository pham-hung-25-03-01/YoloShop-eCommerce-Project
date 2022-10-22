class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories, id: false, primary_key: :inventory_id do |t|
      t.uuid :inventory_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :product_id, null: false
      t.string :size, null: false
      t.text :color_url, null: false, unique: true
      t.integer :quantity_of_inventory, null: false, default: 0

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
