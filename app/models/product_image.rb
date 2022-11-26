class ProductImage < ApplicationRecord
  belongs_to :product
  
  validates_associated :product
  validates :product_id, presence: true
  validates :image_url, presence: true, uniqueness: true
end
