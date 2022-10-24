class CreateAges < ActiveRecord::Migration[7.0]
  def change
    create_table :ages, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.text :age_name, null: false, unique: true

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
