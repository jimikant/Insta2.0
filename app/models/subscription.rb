# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # scope :prod_order, -> { order(created_at: :desc) }
end
