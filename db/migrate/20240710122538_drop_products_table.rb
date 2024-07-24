# frozen_string_literal: true

class DropProductsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :products
  end

  def down
    create_table :products do |t|
      t.string :product_id
      t.string :name
      t.text :description
      t.integer :price
      t.string :currency

      t.timestamps
    end
  end
end
