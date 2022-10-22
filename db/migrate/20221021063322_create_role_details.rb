class CreateRoleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :role_details, id: false, primary_key: [:permission_id, :role_id] do |t|
      t.uuid :permission_id, null: false
      t.uuid :role_id, null: false
      t.datetime :created_at, null: false, default: -> { 'now()' }
      t.uuid :created_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
    execute 'ALTER TABLE role_details ADD PRIMARY KEY (permission_id, role_id);'
  end
end
