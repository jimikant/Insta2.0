# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def send_invite_email
    @user = params[:user]
    @url  = edit_user_password_url(reset_password_token: @user.reset_password_token)
    mail(to: @user.email, subject: 'You have been invited to set your password')
  end
end
