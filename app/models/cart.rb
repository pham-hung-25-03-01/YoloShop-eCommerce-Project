class Cart < ApplicationRecord
    self.primary_keys = :user_id, :inventory_id

    belongs_to :user
    belongs_to :inventory

    validates :user_id, presence: true, uniqueness: {scope: :inventory_id}
    validates :inventory_id, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :updated_by, presence: true
end
