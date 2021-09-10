class Tag < ApplicationRecord
  has_many :product_tag_maps, dependent: :destroy
  has_many :products, through: :product_tag_maps

  has_many :review_tag_maps, dependent: :destroy
  has_many :reviews, through: :review_tag_maps
end
