# frozen_string_literal: true

class StripeSubscriptionService
  def initialize(subscription)
    @subscription = subscription
  end

  def sync_subscription_from_stripe
    user = User.find_by(stripe_customer_id: @subscription.customer)

    return unless user

    product = Product.find_by(stripe_product_id: @subscription.items.data.first.price.product)

    return unless product

    subscription_record = user.subscriptions.find_or_initialize_by(stripe_subscription_id: @subscription.id,
                                                                   product_id: product.id)
    subscription_record.product_name = product.name
    subscription_record.product_id = product.id
    subscription_record.stripe_product_id = product.stripe_product_id
    subscription_record.stripe_price_id = product.stripe_price_id
    subscription_record.username = user.username
    subscription_record.stripe_customer_id = user.stripe_customer_id

    # Update subscription attributes
    subscription_record.status = @subscription.status
    subscription_record.active = @subscription.status == 'active'

    # Save the subscription record
    begin
      subscription_record.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.debug { "Error saving subscription: #{e.message}" }
    end
  end
end
