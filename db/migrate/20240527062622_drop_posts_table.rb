# frozen_string_literal: true

class DropPostsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :posts
  end

  def down
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.timestamps
    end
  end
end
