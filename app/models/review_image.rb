class ReviewImage < ApplicationRecord
  belongs_to :review
  has_many_attached :images

  validates :description, presence: true
end
