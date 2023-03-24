class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization

  protected

  def configure_permitted_parameters
    attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
    devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

end
