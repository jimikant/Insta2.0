class ChangeCustomerIdToStripeCustomerIdInSubscriptions < ActiveRecord::Migration[7.1]
  def change
    # Remove the old column
    remove_column :subscriptions, :customer_id, :string

    # Add the new column
    add_column :subscriptions, :stripe_customer_id, :string
  end
end
