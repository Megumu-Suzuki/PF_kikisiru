class ReviewImage < ApplicationRecord
  belongs_to :review
  has_many_attached :images

  validate :image_presence
  validates :description, presence: true

  def image_presence
    unless images.attached?
      errors.add(:image, 'を添付してください')
    end
  end
end
