class Category < ApplicationRecord
  self.primary_key = :category_id

  has_many :products
  
  validates_associated :products

  validates :category_name, presence: true, uniqueness: true, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
end
