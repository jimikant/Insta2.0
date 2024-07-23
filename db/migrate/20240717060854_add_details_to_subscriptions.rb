class AddDetailsToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :product_name, :string
    add_column :subscriptions, :stripe_product_id, :string
    add_column :subscriptions, :stripe_price_id, :string
    add_column :subscriptions, :username, :string
  end
end
