class AddProductIdAndCurrencyToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :product_id, :string
    add_column :products, :currency, :string
  end
end
