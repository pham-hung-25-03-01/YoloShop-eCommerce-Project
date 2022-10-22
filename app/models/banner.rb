class Banner < ApplicationRecord
  self.primary_key = :banner_id

  belongs_to :admin
  belongs_to :event

  validates :event_id, uniqueness: true
  validates :admin_id, presence: true
  validates :banner_url, presence: true, uniqueness: true
end
