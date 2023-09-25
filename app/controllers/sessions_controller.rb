class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.present? && user.is_active
      session[:unverified_user_id] = user.id
      flash[:notice] = "Complete this 2-factor authentication"
      redirect_to two_factor_authentication_session_path(user)
    else
      flash[:error] = t("session.error")
      redirect_to root_path
    end
  end

  def two_factor_authentication
    @user = User.find(session[:unverified_user_id])
  end

  def authenticate
    user = User.find(session[:unverified_user_id])

    if user.authenticate_otp(params[:otp])
      user.update(qr_option: false) if user.qr_option
      session[:user_id] = user.id
      session[:unverified_user_id] = nil
      redirect_to transactions_path, flash: { success: "Logged in successfully!" }
    else
      redirect_to two_factor_authentication_session_path(user),
                  flash: { error: "OTP is not valid, please enter valid OTP" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
