class InventoryQuantityLog < ApplicationRecord
  belongs_to :inventory
  belongs_to :admin_user

  validates :inventory_id, presence: true
  validates :admin_user_id, presence: true
  validates :quantity_of_import, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity_of_export, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
