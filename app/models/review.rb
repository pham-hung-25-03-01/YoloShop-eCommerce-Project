class Review < ApplicationRecord
  self.primary_keys = :product_id, :user_id

  belongs_to :product
  belongs_to :user

  #validates :user_score_rating, numericality: { greater_than: 0 }
  #validates :is_favored, presence: true
end
