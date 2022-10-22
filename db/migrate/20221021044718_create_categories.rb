class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: false, primary_key: :category_id do |t|
      t.uuid :category_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.text :category_name, null: false, unique: true

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
