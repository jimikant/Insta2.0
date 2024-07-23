class AddStatusToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :status, :string
  end
end
