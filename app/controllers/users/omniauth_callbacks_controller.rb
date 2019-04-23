class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_oauth request.env['omniauth.auth']
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      redirect_to_failure
    end
  end

  def failure
    redirect_to_failure
  end

  private

  def redirect_to_failure
    redirect_to root_path, error: 'Unable to sign in with provider'
  end
end
