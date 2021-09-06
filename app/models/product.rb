class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true

  enum manufacture: { "A社": 0, "B社": 1, "C社": 2, "D社": 3, "E社": 4, "その他": 5}
  enum phase: { "なし": 0, "単相100V": 1, "単相200V": 2, "3相200V": 3}

end
