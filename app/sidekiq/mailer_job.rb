class MailerJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.with(user: user).welcome_email.deliver_now
  end
end
