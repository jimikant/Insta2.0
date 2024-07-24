# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret)
      )
    rescue JSON::ParserError => e
      render json: { error: e.message }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    # Handle_customer
    stripe_customer = event.data.object
    case event.type
    when 'customer.created'
      GetStripeCustomerService.new(stripe_customer[:id]).get_customer_from_stripe
    when 'customer.updated'
      GetStripeCustomerService.new(stripe_customer[:id]).get_customer_from_stripe
    when 'customer.deleted'
      User.find_by(stripe_customer_id: stripe_customer[:id])&.destroy
    end

    # Handle_product
    product = event.data.object
    case event.type
    when 'product.created'
      SyncStripeProductService.new(product[:id]).sync_product_from_stripe
    when 'product.updated'
      SyncStripeProductService.new(product[:id]).sync_product_from_stripe
    when 'product.deleted'
      Product.find_by(stripe_product_id: product[:id])&.destroy
    end

    # Handle_subscription
    subscription = event.data.object
    case event.type
    when 'customer.subscription.created'
      StripeSubscriptionService.new(subscription).sync_subscription_from_stripe
    when 'customer.subscription.updated'
      StripeSubscriptionService.new(subscription).sync_subscription_from_stripe
    when 'invoice.payment_succeeded'
      StripeSubscriptionService.new(subscription).sync_subscription_from_stripe
    when 'customer.subscription.deleted'
      Subscription.find_by(stripe_subscription_id: subscription[:id])&.destroy
    end
  end
end
