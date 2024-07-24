# frozen_string_literal: true

require 'exception_notification/rails'
require 'slack-notifier'

ExceptionNotification.configure do |config|
  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  # config.add_notifier :email, {
  #   email_prefix: "[ERROR] ",
  #   sender_address: %("Notifier" <jimyvaghela010203@gmail.com>),
  #   exception_recipients: %w[jimiv.essence@gmail.com]
  # }

  # Slack notifier sends notifications by slack.
  config.add_notifier :slack, {
    webhook_url: 'https://hooks.slack.com/services/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',
    channel: '#insta',
    additional_parameters: {
      mrkdwn: true
    }
  }
end
