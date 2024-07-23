class GetStripeCustomerService

  def initialize(stripe_customer_id)
    @stripe_customer_id = stripe_customer_id
  end

  def get_customer_from_stripe
    stripe_customer = Stripe::Customer.retrieve(@stripe_customer_id)

    user = User.find_or_initialize_by(stripe_customer_id: stripe_customer.id)
    user.username = stripe_customer.name
    user.email = stripe_customer.email

    user.save(validate: false)
  end
end
