class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts, id: false, primary_key: [:user_id, :inventory_id] do |t|
      t.uuid :user_id, null: false
      t.uuid :inventory_id, null: false
      t.integer :quantity, null: false
      t.timestamps
      t.uuid :updated_by, null: false
    end
    execute 'ALTER TABLE carts ADD PRIMARY KEY (user_id, inventory_id);'
  end
end
