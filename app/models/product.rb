class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true

  enum manufacture: { "A社": 0, "B社": 1, "C社": 2, "D社": 3, "E社": 4, "その他": 5}
  enum phase: { "1φ100V": 0, "1φ200V": 1, "3φ200V": 2}

end
