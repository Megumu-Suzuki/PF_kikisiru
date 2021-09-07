class ProductImage < ApplicationRecord
  belongs_to :product
  has_many_attached :images

  validates :description, presence: true
end
