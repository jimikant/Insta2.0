# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  # Attach Avtar to Profile_model
  has_one_attached :avtar, dependent: :destroy
  def avtar_variant
    avtar.variant(resize_to_limit: [250, 250]).processed
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, numericality: true
  validates :address, presence: true
  validates :user_id, uniqueness: true

  # Foe Friendly_id
  extend FriendlyId
  friendly_id :first_name, use: :slugged

  def should_generate_new_friendly_id?
    first_name_changed? || super
  end
end
