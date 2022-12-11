class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  validates :last_name, presence: true
  validates :phone_number, presence: true, uniqueness: true, on: [:create, :update]
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
  def self.new_with_session params, session
    super.tap do |user|
      if (data = session["devise.facebook_data"]) && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  def self.from_omniauth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0, 20]
    #   user.first_name = ' '
    #   user.last_name = auth.info.name
    #   user.avatar_url = auth.info.image # assuming the user model has an image
    #   # If you are using confirmable and the provider(s) you use validate emails,
    #   # uncomment the line below to skip the confirmation emails.
    #   # user.skip_confirmation!
    # end

    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.nil?
      case auth.provider
      when 'google'
        user = User.new(email: auth.info.email, password: Devise.friendly_token[0, 20], first_name: ' ', last_name: auth.info.name, avatar_url: auth.info.image, provider: auth.provider, uid: auth.uid)
      when 'facebook'
        email = auth.info.email.nil? ? ' ' : auth.info.email
        user = User.new(email: email, password: Devise.friendly_token[0, 20], first_name: auth.info.first_name, last_name: auth.info.last_name, avatar_url: auth.info.picture, provider: auth.provider, uid: auth.uid)
        user.skip_confirmation! if auth.info.email.nil?
      end
      user.updated_by = ENV['ADMIN_USER_ID']
      user.save(validate: false)
    end
    if auth.provider.eql?('facebook') && user.email.eql?(' ') && !auth.info.email.nil?
      user.email = auth.info.email
      user.updated_by = user.id
      user.save
    end
    user
  end
end
