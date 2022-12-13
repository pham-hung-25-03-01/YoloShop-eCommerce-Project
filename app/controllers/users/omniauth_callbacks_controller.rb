# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def facebook
    generic_callback("facebook")
  end

  def google_oauth2
    generic_callback( "google_oauth2" )
  end

  def generic_callback(provider)
    auth
    if @auth.provider.eql?('facebook') && @auth.info.email.nil?
      set_flash_message!(:alert, :not_have_email)
      redirect_to root_path
    else
      @identity = User.from_omniauth(@auth)

      @user = @identity || current_user
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
      else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  # def google_oauth2
  #   user = User.from_omniauth(auth)
  #   if user.present?
  #     sign_out_all_scopes
  #     flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
  #     sign_in_and_redirect user, event: :authentication
  #   else
  #     flash[:alert] =
  #       t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
  #     redirect_to new_user_session_path
  #   end
  # end


  protected
  def after_omniauth_failure_path_for(_scope)
    #new_user_session_path
    root_path
  end
  def after_sign_in_path_for(resource_or_scope)
    request.env['omniauth.origin'] || stored_location_for(resource_or_scope) || root_path
  end
  private
  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
