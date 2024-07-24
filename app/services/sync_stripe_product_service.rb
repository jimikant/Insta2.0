# frozen_string_literal: true

class SyncStripeProductService
  def initialize(stripe_product_id)
    @stripe_product_id = stripe_product_id
  end

  def sync_product_from_stripe
    stripe_product = Stripe::Product.retrieve(@stripe_product_id)
    stripe_prices = Stripe::Price.list(product: stripe_product.id)

    # Assuming you are interested in the first price object
    stripe_price = stripe_prices.data.first

    product = Product.find_or_initialize_by(stripe_product_id: stripe_product.id)
    product.name = stripe_product.name
    product.description = stripe_product.description
    product.price = stripe_price.unit_amount.to_f / 100.0 # price in USD
    product.currency = stripe_price.currency
    product.active = stripe_product.active
    product.stripe_price_id = stripe_price.id

    if stripe_product.images.present?
      image_url = stripe_product.images.first # Get the first image URL
      downloaded_image = URI.open(image_url)
      product.image.attach(io: downloaded_image, filename: File.basename(URI.parse(image_url).path))
    end

    product.save!
  end
end
