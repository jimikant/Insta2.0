# frozen_string_literal: true

class RemoveSlugFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :slug, :string
  end
end
