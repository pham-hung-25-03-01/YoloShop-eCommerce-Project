class CreateProductImages < ActiveRecord::Migration[7.0]
  def change
    create_table :product_images, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :product_id, null: false
      t.text :image_url, null: false, unique: true
      t.boolean :is_default, null: false, default: false
      t.datetime :created_at, null: false, default: -> { 'now()' }
      t.uuid :created_by, null: false
    end
  end
end
