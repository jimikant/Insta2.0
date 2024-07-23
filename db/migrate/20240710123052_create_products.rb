class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :stripe_product_id
      t.string :name
      t.text :description
      t.integer :price
      t.string :currency
      t.boolean :active

      t.timestamps
    end
  end
end
