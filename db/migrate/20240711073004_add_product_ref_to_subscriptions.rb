# frozen_string_literal: true

class AddProductRefToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :subscriptions, :product, null: false, foreign_key: true
  end
end
