class PasswordsController < ApplicationController

  skip_before_action :authenticate_user!

  def edit
    @user = User.find_by(reset_password_token: params[:reset_password_token])

    if @user.nil? || @user.reset_password_token_expired?
      flash[:alert] = "Password reset token is invalid or has expired."
      redirect_to request.referrer
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:user][:reset_password_token])

    p 66666666666666666666666666666666666666666
    p @user
    p 666666666666666666666666666666666666666666666666

    if @user.nil?
      flash[:alert] = "Invalid reset password token."
      redirect_to request.referrer
      return
    end

    if @user.update(password_params)
      @user.clear_reset_password_token! # Clear the reset token once the password is updated
      flash[:notice] = "Password has been reset successfully."
      redirect_to request.referrer # Redirect to the login page
    else
      flash.now[:alert] = "There was a problem resetting your password."
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
