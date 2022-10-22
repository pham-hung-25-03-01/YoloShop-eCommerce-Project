class CreateProductPriceLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :product_price_logs, id: false, primary_key: :product_price_log_id do |t|
      t.uuid :product_price_log_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :admin_id, null: false
      t.uuid :product_id, null: false
      t.money :import_price, null: false, default: 0
      t.money :sell_price, null: false, default: 0

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
