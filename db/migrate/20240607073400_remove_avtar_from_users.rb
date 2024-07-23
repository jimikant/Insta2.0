class RemoveAvtarFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :avtar, :string
  end
end
