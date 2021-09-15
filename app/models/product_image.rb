class ProductImage < ApplicationRecord
  belongs_to :product
  has_many_attached :images

  #validate :image_presence
  validates :description, presence: true

  def image_presence
    unless image.attached?
      errors.add(:image, '画像を添付してください')
    end
  end

end
