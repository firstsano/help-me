require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  add_flash_types :success, :error
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_gon_user, if: :user_signed_in?

  protected

  def set_gon_user
    gon.user = current_user.id
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
