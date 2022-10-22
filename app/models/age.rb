class Age < ApplicationRecord
  self.primary_key = :age_id

  has_many :products

  validates_associated :products

  validates :age_name, presence: true, uniqueness: true, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
end
