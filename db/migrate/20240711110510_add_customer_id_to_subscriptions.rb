class AddCustomerIdToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :customer_id, :string
  end
end
