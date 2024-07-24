# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # scope :prod_order, -> { order(created_at: :desc) }

  after_destroy :cancel_user_subscription

  def cancel_user_subscription
    return if stripe_subscription_id.blank?

    begin
      Stripe::Subscription.delete(stripe_subscription_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Stripe subscription cancellation failed: #{e.message}"
    end
  end
end
