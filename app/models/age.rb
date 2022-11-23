class Age < ApplicationRecord
  has_many :products

  validates :age_name, presence: true, uniqueness: true, length: { maximum: 100, too_long: '%{count} characters is the maximum allowed' }
end
