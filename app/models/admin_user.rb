class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  validates :phone_number, presence: true, uniqueness: true, on: [:create, :update]
  validates :last_name, presence: true
  validates :permission, presence: true
  validate :password_complexity, :first_name_complexity, :last_name_complexity, :phone_number_complexity
  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/)
      errors.add :password, "must contains at least six characters, including at least one lowercase letter, one uppercase letter, one digit and one special character"
    end
  end
  def first_name_complexity
    if first_name.present? and not first_name.match(/^[a-zA-Z ,.'-]*$/)
      errors.add :first_name, "does not contain special characters"
    end
  end
  def last_name_complexity
    if last_name.present? and not last_name.match(/^[a-zA-Z ,.'-]*$/)
      errors.add :last_name, "does not contain special characters"
    end
  end
  def phone_number_complexity
    if phone_number.present? and not phone_number.match(/[0]\d{9}/)
      errors.add :phone_number, "not in Vietnam area"
    end
  end
end
