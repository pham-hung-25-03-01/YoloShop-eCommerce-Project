class Event < ApplicationRecord
  self.primary_key = :event_id

  has_one :banners
  has_many :products

  validates_associated :banners
  validates_associated :products

  validates :event_name, presence: true, uniqueness: true, length: { maximum: 500, too_long: '%{count} characters is the maximum allowed' }
end
