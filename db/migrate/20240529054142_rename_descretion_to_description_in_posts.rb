class RenameDescretionToDescriptionInPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :descreption, :description
  end
end
