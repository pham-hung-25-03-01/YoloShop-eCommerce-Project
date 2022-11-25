class ProductImage < ApplicationRecord
  belongs_to :product
  
  validates :product_id, presence: true
  validates :image_url, presence: true, uniqueness: true
end
