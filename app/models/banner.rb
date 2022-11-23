class Banner < ApplicationRecord
  belongs_to :admin_user
  belongs_to :event, optional: true

  validates :admin_user_id, presence: true
  validates :banner_url, presence: true, uniqueness: true
end