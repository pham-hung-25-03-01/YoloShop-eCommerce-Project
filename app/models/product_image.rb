class ProductImage < ApplicationRecord
  belongs_to :product

  validates_associated :products
  
  validates :product_id, presence: true
  validates :image_url, presence: true, uniqueness: true
end
