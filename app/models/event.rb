class Event < ApplicationRecord
  has_one :banner
  has_many :products

  validates_associated :banner
  validates_associated :products

  validates :event_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
