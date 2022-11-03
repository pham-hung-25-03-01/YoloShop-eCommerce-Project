class Inventory < ApplicationRecord
  has_many :inventory_quantity_logs
  has_many :order_details
  has_many :carts
  belongs_to :product

  validates_associated :inventory_quantity_logs
  validates_associated :order_details
  validates_associated :carts

  validates :product_id, presence: true
  validates :size, presence: true, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
  validates :color_url, presence: true
  validates :quantity_of_inventory, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
