class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
