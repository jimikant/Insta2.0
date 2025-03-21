# frozen_string_literal: true

class AddStripeCustomerIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_customer_id, :string
  end
end
