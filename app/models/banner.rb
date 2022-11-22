class Banner < ApplicationRecord
  belongs_to :admin_user
  belongs_to :event

  validates :event_id, uniqueness: true
  validates :admin_user_id, presence: true
  validates :banner_url, presence: true, uniqueness: true
end
