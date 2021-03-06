class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  # レビュー画像
  has_many :review_images, dependent: :destroy
  accepts_nested_attributes_for :review_images, allow_destroy: true
  # タグ機能
  has_many :review_tag_maps, dependent: :destroy
  has_many :tags, through: :review_tag_maps

  validates :user_id, :product_id, :title, :comment, :evaluation, presence: true

  def save_tag(sent_tags)
    # pluckメソッド =アクティブストレージから指定のカラムのデータをZZ
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    # 古いタグの削除
    old_tags.each do |old_tag|
      tags.delete(Tag.find_by(name: old_tag))
    end
    # 新しいタグの保存
    new_tags.each do |new_tag|
      tag = Tag.find_or_create_by(name: new_tag)
      maps = ReviewTagMap.find_or_create_by(review_id: id, tag_id: tag.id)
      review_tag_maps.push(maps)
      # pushメソッド = 追加で保存する
      # a="1"  a.push("2")  a= "1", "2"
      # self.tags.push(review_tag_map)
    end
  end

  def valid_of_specified?(*columns)
    columns.each do |column|
      return false if errors.messages.include?(column)
    end
    true
  end
end
