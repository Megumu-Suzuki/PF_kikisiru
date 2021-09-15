class ReviewImage < ApplicationRecord
  belongs_to :review
  has_one_attached :image

  validates :image_presence
  validates :description, presence: true

  def image_presence
    if image.attached?
      if !image.content_type.in?(%('image/png image/png'))
        errors.add(:image, 'にはjpegまたはpngファイルを添付してください')
      end
    else
      errors.add(:image, '画像を添付してください')
    end
  end

end
