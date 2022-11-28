class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details, id: false, primary_key: [:inventory_id, :order_id] do |t|
      t.uuid :inventory_id, null: false
      t.uuid :order_id, null: false
      t.integer :quantity_of_order, null: false
      t.decimal :sell_price, precision: 15, scale: 2, null: false
      t.float :product_discount, null: false

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
    end
    execute 'ALTER TABLE order_details ADD PRIMARY KEY (inventory_id, order_id);'
  end
end
