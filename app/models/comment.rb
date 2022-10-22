class Comment < ApplicationRecord
  self.primary_key = :comment_id

  belongs_to :product
  belongs_to :user

  validates :product_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1000, too_long: '%{count} characters is the maximum allowed' }
end
