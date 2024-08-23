# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @products = Product.includes(image_attachment: :blob).all
  end

  def create
    @product = Product.find_by(stripe_product_id: params[:stripe_product_id])

    if @product
      customer_id = current_user.stripe_customer_id

      @session = Stripe::Checkout::Session.create({
                                                    customer: customer_id,
                                                    line_items: [{
                                                      price: @product.stripe_price_id,
                                                      quantity: 1
                                                    }],
                                                    mode: 'subscription',
                                                    success_url: dashboard_url,
                                                    cancel_url: dashboard_url
                                                  })

      # Respond with JavaScript to redirect
      respond_to do |format|
        format.html { redirect_to @session.url, allow_other_host: true }
        format.js { render js: "window.location.href='#{@session.url}'" }
      end
    else
      redirect_to subscriptions_path, alert: 'Product not found'
    end
  rescue Stripe::InvalidRequestError => e
    flash[:alert] = e.message
    redirect_to subscriptions_path
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(stripe_subscription_id: params[:stripe_subscription_id])

    # p 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
    #   puts "subs :-  #{@subscription.inspect}"
    # p 22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222

    if @subscription
      Stripe::Subscription.cancel(@subscription.stripe_subscription_id)

      @subscription.update!(status: 'canceled', active: false)
      flash[:notice] = 'Subscription has been canceled.'
    else
      flash[:alert] = 'Subscription not found.'
    end

    redirect_to dashboard_path
  end
end
