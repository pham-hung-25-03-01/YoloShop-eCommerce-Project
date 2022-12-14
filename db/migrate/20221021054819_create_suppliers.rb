class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.text :supplier_name, null: false, unique: true
      t.datetime :contract_date, null: false, default: -> { 'now()' }
      t.string :phone_number
      t.string :email
      t.text :address
      t.boolean :is_cooperated, null: false, default: true

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
