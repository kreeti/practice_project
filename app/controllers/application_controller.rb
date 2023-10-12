class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :authenticate_user

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate_user
    redirect_to root_path unless current_user
  end

  def authenticate_admin_user
    return if current_user.admin?

    redirect_back(fallback_location: signin_path, alert: "Unauthorised access!")
  end
end
