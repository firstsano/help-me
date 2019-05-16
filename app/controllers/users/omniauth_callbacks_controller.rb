class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  before_action :sign_in_by_authorization!, only: %i[google_oauth2 twitter]
  before_action :restrict_empty_session_auth!, :load_email, only: :register_auth
  before_action :load_confirmation_request, only: :confirm_auth

  def google_oauth2
    user = User.generate_for_oauth auth.info.name, auth.info.email
    user.generate_auth auth.provider, auth.uid
    sign_in_user user
  end

  def twitter
    session["devise.provider_data"] = auth
    redirect_to users_auth_email_confirmation_path
  end

  def new_auth
    render :new_auth
  end

  def register_auth
    user = User.find_by email: @email
    if user&.has_provider?(auth.provider)
      redirect_to root_path, error: "You already have another #{auth.provider} account."
    else
      username = user&.name || auth.info.name
      request = OmniauthRequest.create! email: @email, provider: auth.provider, uid: auth.uid, name: username
      request.send_confirmation
      redirect_to root_path, notice: 'Follow email link to confirm your account'
    end
  end

  def confirm_auth
    @request.confirm
    user = User.generate_for_oauth @request.name, @request.email
    if user.has_provider?(@request.provider)
      redirect_to root_path, error: "You already have another #{@request.provider} account."
    else
      user.generate_auth @request.provider, @request.uid
      redirect_to new_user_session_path, notice: 'Your email address has been successfully confirmed.'
    end
  end

  def failure
    set_flash_message(:error, :common_failure, kind: auth.provider) if is_navigational_format?
    redirect_to root_path
  end

  private

  def load_confirmation_request
    @request = OmniauthRequest.unconfirmed.actual.find_by confirmation_token: params[:token]
    redirect_to root_path, error: "Request token does not exist or has already been used." unless @request
  end

  def load_email
    @email = register_auth_params[:email]
    unless @email =~ Devise.email_regexp
      @errors = 'Invalid email'
      render :new_auth
    end
  end

  def register_auth_params
    params.require(:user).permit(:email)
  end

  def restrict_empty_session_auth!
    redirect_to root_path, error: "Authentication data is missing" unless auth
  end

  def sign_in_by_authorization!
    user = User.find_by_auth auth.provider, auth.uid
    sign_in_user user if user
  end

  def sign_in_user(user, provider = auth.provider)
    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end

  def auth
    auth_session_data = session["devise.provider_data"]
    session_auth = OmniAuth::AuthHash.new auth_session_data if auth_session_data
    request.env['omniauth.auth'] || session_auth
  end
end
