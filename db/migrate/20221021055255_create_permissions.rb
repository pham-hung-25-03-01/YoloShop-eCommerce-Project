class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions, id: false, primary_key: :permission_id do |t|
      t.uuid :permission_id, primary_key: true, null: false, default: 'gen_random_uuid()'
      t.text :permission_name, null: false, unique: true

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
