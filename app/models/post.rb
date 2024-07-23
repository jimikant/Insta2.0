class Post < ApplicationRecord

  belongs_to :user
  has_and_belongs_to_many :tags, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  validates :image, presence: true
  validates :title, presence: true
  validates :description, presence: true

  default_scope -> { order(created_at: :desc) }

  #Foe Friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
