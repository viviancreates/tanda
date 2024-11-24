class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user! 

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :avatar])
  end
end
