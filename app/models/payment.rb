class Payment < ApplicationRecord
  has_many :invoices

  validates_associated :invoices

  validates :payment_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
