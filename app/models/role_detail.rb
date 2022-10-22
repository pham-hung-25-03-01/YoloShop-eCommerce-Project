class RoleDetail < ApplicationRecord
  self.primary_keys = :permission_id, :role_id

  belongs_to :permission
  belongs_to :role
end
