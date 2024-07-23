class Subscription < ApplicationRecord

  belongs_to :user
  belongs_to :product

  # scope :prod_order, -> { order(created_at: :desc) }

  after_destroy :cancel_user_subscription

  def cancel_user_subscription
    if stripe_subscription_id.present?
      begin
        Stripe::Subscription.delete(stripe_subscription_id)
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error "Stripe subscription cancellation failed: #{e.message}"
      end
    end
  end
end
