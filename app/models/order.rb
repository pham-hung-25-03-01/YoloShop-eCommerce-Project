class Order < ApplicationRecord
  has_many :order_details
  belongs_to :user
  belongs_to :coupon, optional: true

  validates_associated :order_details

  validates :user_id, presence: true
  validates :ship_date, comparison: { greater_than_or_equal_to: :created_at }
  validates :apartment_number, presence: true
  validates :street, presence: true
  validates :ward, presence: true
  validates :district, presence: true
  validates :province, presence: true
  validates :status, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
