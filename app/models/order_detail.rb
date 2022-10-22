class OrderDetail < ApplicationRecord
  self.primary_keys = :inventory_id, :order_id

  belongs_to :inventory
  belongs_to :order

  validates :quantity_of_order, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sell_price, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
  validates :product_discount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
