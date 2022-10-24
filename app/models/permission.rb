class Permission < ApplicationRecord
  has_many :permissions
  
  validates :permission_name, presence: true, uniqueness: true, length: { maximum: 200, too_long: '%{count} characters is the maximum allowed' }
end
