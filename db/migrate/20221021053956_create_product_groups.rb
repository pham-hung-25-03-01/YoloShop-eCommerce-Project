class CreateProductGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :product_groups, id: false, primary_key: :product_group_id do |t|
      t.uuid :product_group_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.text :product_group_name, null: false, unique: true

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
