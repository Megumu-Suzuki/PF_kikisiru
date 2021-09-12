class ProductTagMap < ApplicationRecord
  belongs_to :product
  belongs_to :tag

  #validates :product_id, presence: true
  validates :tag_id, presence: true
end
