class Role < ApplicationRecord
  has_many :role_details
  has_many :admins

  validates_associated :role_details
  validates_associated :admins

  validates :role_name, presence: true, uniqueness: true, length: { maximum: 300, too_long: '%{count} characters is the maximum allowed' }
  validates :description, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
