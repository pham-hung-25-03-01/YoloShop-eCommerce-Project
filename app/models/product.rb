class Product < ApplicationRecord
  has_many :product_images
  has_many :comments
  has_many :product_price_logs
  has_many :inventories
  has_many :reviews
  belongs_to :event, optional: true
  belongs_to :supplier
  belongs_to :product_group
  belongs_to :category
  belongs_to :age

  validates_associated :event
  validates_associated :age
  validates_associated :product_group
  validates_associated :category
  #validates_associated :product_images
  validates_associated :comments
  validates_associated :product_price_logs
  validates_associated :inventories
  validates_associated :reviews

  validates :supplier_id, presence: true
  validates :product_group_id, presence: true
  validates :category_id, presence: true
  validates :age_id, presence: true

  validates :product_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
  validates :meta_title, presence: true, uniqueness: true
  validates :origin, length: { maximum: 300, too_long: '%{count} characters is the maximum allowed' }
  validates :description, length: { maximum: 1000, too_long: '%{count} characters is the maximum allowed' }
  validates :gender, presence: true
  validates :warranty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :import_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, format: { with: /\d{1,9}(\.\d{0,2})?/ }
  validates :sell_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, format: { with: /\d{1,9}(\.\d{0,2})?/ }
  validates :product_discount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :score_rating, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :number_of_rates, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
