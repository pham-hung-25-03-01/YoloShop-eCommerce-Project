class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons, id: :string do |t|
      t.datetime :start_date, null: false, default: -> { 'now()' }
      t.datetime :end_date, null: false
      t.float :coupon_discount, null: false, default: 0
      t.integer :number_of_uses, null: false, default: 0

      t.timestamps
      t.uuid :created_by, null: false
      t.uuid :updated_by, null: false
      t.boolean :is_actived, null: false, default: true
      t.datetime :deleted_at
      t.uuid :deleted_by
    end
  end
end
