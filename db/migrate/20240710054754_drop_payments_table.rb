# frozen_string_literal: true

class DropPaymentsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :payments
  end

  def down
    create_table :payments do |t|
      t.integer :amount
      t.text :description
      t.string :status
      t.string :stripe_charge_id
      t.integer :customer_id
      t.timestamps
    end
  end
end
