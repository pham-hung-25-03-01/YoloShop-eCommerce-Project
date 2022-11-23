class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :event_id
      t.uuid :supplier_id, null: false
      t.uuid :product_group_id, null: false
      t.uuid :category_id, null: false
      t.uuid :age_id
      t.text :product_name, null: false, unique: true
      t.text :meta_title, null: false, unique: true
      t.text :origin
      t.text :description
      t.boolean :gender, null: false
      t.integer :warranty, null: false, limit: 3, default: 0
      t.decimal :import_price, precision: 15, scale: 2, null: false, default: 0
      t.decimal :sell_price, precision: 15, scale: 2, null: false, default: 0
      t.float :product_discount, null: false, default: 0
      t.integer :shipping, null: false, limit: 3, default: 1
      t.float :score_rating, null: false, default: 0
      t.integer :number_of_rates, null: false, default: 0
      t.boolean :is_available, null: false, default: false

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
