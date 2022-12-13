class Supplier < ApplicationRecord
  has_many :products

  validates_associated :products

  validates :supplier_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
  validates :contract_date, presence: true
  validates :contract_date, comparison: { greater_than_or_equal_to: Date.today }, on: [:create]
  validates :phone_number, format: { with: /\d+/ }, uniqueness: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }, uniqueness: true
  validates :address, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
