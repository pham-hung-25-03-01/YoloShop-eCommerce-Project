class ProductGroup < ApplicationRecord
  has_many :products

  validates_associated :products

  validates :product_group_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
