class CreateProductImages < ActiveRecord::Migration[7.0]
  def change
    create_table :product_images, id: false, primary_key: :product_image_id do |t|
      t.uuid :product_image_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.uuid :product_id, null: false
      t.text :image_url, null: false, unique: true
      t.datetime :created_at, null: false, default: -> { 'now()' }
      t.uuid :created_by, null: false
    end
  end
end
