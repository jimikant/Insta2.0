# frozen_string_literal: true

class Tag < ApplicationRecord
  has_and_belongs_to_many :posts

  validates :name, presence: true, uniqueness: true, format: { with: /\A#/, message: "Must start with  '#'" }

  scope :ordered_alphabetically, -> { order(name: :asc) }

  # Foe Friendly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
