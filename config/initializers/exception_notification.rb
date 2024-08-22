# frozen_string_literal: true

require 'exception_notification/rails'
require 'slack-notifier'

ExceptionNotification.configure do |config|
  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  # config.add_notifier :email, {
  #   email_prefix: "[ERROR] ",
  #   sender_address: %("Notifier" <noreply@example.com>),
  #   exception_recipients: %w[noreply@example.com]
  # }

  # Slack notifier sends notifications by slack.
  config.add_notifier :slack, {
    webhook_url: Rails.application.credentials.dig(:slack, :webhook_url),
    channel: Rails.application.credentials.dig(:slack, :channel),
    additional_parameters: {
      mrkdwn: true
    }
  }
end
