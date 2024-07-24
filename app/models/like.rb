# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :user_id, uniqueness: { scope: :post_id, message: 'has already liked this post' }
end
