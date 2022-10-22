class ProductImage < ApplicationRecord
  self.primary_key = :product_image_id

  belongs_to :product

  validates :product_id, presence: true
  validates :image_url, presence: true, uniqueness: true
end
