class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: false, primary_key: :order_id do |t|
      t.uuid :order_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :user_id, null: false
      t.string :coupon_id
      t.datetime :ship_date
      t.text :apartment_number, null: false
      t.text :street, null: false
      t.text :ward, null: false
      t.text :district, null: false
      t.text :province, null: false
      t.integer :status, null: false, limit: 1, default: 0

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
