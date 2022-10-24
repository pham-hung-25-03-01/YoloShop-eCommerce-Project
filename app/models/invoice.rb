class Invoice < ApplicationRecord
  belongs_to :order
  belongs_to :admin
  belongs_to :payment

  validates :order_id, presence: true, uniqueness: true
  validates :admin_id, presence: true
  validates :payment_id, presence: true
  validates :total_money, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
  validates :total_money_discount, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
  validates :total_money_payment, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
end
