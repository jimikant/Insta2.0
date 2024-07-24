# frozen_string_literal: true

class AddStatusAndActiveToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :status, :string
    add_column :subscriptions, :active, :boolean
  end
end
