class ApplicationController < ActionController::Base

  # Ensure Devise helpers are included
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  #For_devise
  before_action :authenticate_user!


  def after_sign_in_path_for(resource)
    if resource.admin?
      user_index_path
    else
      dashboard_path
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?


  protected
  #For permite Extra attributes/parameters to Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role, :stripe_customer_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :role, :stripe_customer_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.admin?
      redirect_to user_index_path, alert: exception.message
    else
      redirect_to dashboard_path, alert: exception.message
    end
  end
end
