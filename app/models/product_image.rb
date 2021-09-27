class ProductImage < ApplicationRecord
  belongs_to :product
  has_many_attached :images

  validate :image_presence
  validates :description, presence: true, length: { maximum: 15 }

  def image_presence
    unless images.attached?
      errors.add(:image, '画像を添付してください')
    end
  end
end
