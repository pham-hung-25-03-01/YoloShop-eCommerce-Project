class ProductPriceLog < ApplicationRecord
  belongs_to :admin
  belongs_to :product

  validates :admin_id, presence: true
  validates :product_id, presence: true
  validates :import_price, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
  validates :sell_price, presence: true, numericality: true, format: { with: /^\d{1,9}(\.\d{0,2})?$/ }
end
