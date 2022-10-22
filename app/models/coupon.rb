class Coupon < ApplicationRecord
  self.primary_key = :coupon_id

  has_many :orders

  validates_associated :orders

  validates :coupon_id, presence: true, uniqueness: true, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than_or_equal_to: :start_date }
  validates :coupon_discount, presence: true, numericality: { greater_than: 0 }
  validates :number_of_uses, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
