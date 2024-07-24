# frozen_string_literal: true

class AddSlugToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :slug, :string
  end
end
