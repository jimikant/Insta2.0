class Product < ApplicationRecord

  has_one_attached :image, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

end
