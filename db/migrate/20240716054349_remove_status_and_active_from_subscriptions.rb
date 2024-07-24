# frozen_string_literal: true

class RemoveStatusAndActiveFromSubscriptions < ActiveRecord::Migration[7.1]
  def change
    remove_column :subscriptions, :status, :string
    remove_column :subscriptions, :active, :boolean
  end
end
