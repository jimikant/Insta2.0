# frozen_string_literal: true

class ChangeProductIdToStripeProductIdInSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :subscriptions, :product, null: false
  end
end
