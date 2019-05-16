require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  add_flash_types :success, :error
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_gon_user, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_path, error: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  protected

  def set_gon_user
    gon.user = current_user.id
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
