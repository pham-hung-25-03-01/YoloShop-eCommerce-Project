class Supplier < ApplicationRecord
  has_many :products

  validates_associated :products

  validates :supplier_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
  validates :contract_date, presence: true, comparison: { greater_than_or_equal_to: :created_at}
  validates :phone_number, format: { with: /\d+$/ }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :address, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
  validates :is_cooperated, presence: true
end
