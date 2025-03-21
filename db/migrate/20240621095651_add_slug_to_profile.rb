# frozen_string_literal: true

class AddSlugToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :slug, :string
    add_index :profiles, :slug, unique: true
  end
end
