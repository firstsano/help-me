class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.find_by_auth provider: auth.provider, uid: auth.uid
    user ||= User.find_by email: auth.info.email
    user ||= User.create_with_password name: auth.info.name, email: auth.info.email, confirmed: Date.now
    user.authorizations.create provider: auth.provider, uid: auth.uid

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      redirect_to root_path
      set_flash_message(:error, :common_failure, kind: "Google") if is_navigational_format?
    end
  end

  def twitter
    user = User.find_by_auth provider: auth.provider, uid: auth.uid

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      redirect_to enter_email_path
    end
  end

  def after_email_twitter_callback
    email = params[:email]
    auth = session["auth"]

    user = User.find_by email: email
    if user.persisted?
      redirect_to root_path if user.has_provider?(provider)
      user.send_confirmation_with_twitter_data
    end

    user ||= User.create_with_password name: auth.info.name, email: email
    user.authorizations.create provider: auth.provider, uid: auth.uid
    user.send_confirmation_devise
  end

  def after_email_link_callback
    token = find_token
    user = token.user
    auth = user.authorizations.create provider: token.provider, uid: token.uid

    if auth.persisted?
      redirect_to new_user_session_path
    else
      redirect_to root_path
      set_flash_message(:error, :common_failure, kind: "Twitter") if is_navigational_format?
    end
  end

  def failure
    redirect_to root_path, error: 'Unable to sign in with provider'
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
