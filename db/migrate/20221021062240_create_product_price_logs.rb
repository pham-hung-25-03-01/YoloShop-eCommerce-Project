class CreateProductPriceLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :product_price_logs, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :admin_user_id, null: false
      t.uuid :product_id, null: false
      t.decimal :import_price, precision: 15, scale: 2, null: false, default: 0
      t.decimal :sell_price, precision: 15, scale: 2, null: false, default: 0

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
