class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid :order_id, null: false
      t.uuid :admin_user_id
      t.uuid :payment_id, null: false
      t.string :bank_code
      t.string :bank_transaction_no
      t.string :transaction_no
      t.decimal :total_money, precision: 15, scale: 2, null: false
      t.decimal :total_money_discount, precision: 15, scale: 2, null: false
      t.decimal :total_money_payment, precision: 15, scale: 2, null: false

      t.timestamps
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
