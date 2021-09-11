class Review < ApplicationRecord

  belongs_to :user
  belongs_to :product
  #レビュー画像
  has_many :review_images, dependent: :destroy
  accepts_nested_attributes_for :review_images, allow_destroy: true
  #タグ機能
  has_many :review_tag_maps, dependent: :destroy
  has_many :tags, through: :review_tag_maps

  def save_tag(sent_tags)
    unless self.tags.nil?
      # pluckメソッド =アクティブストレージから指定のカラムのデータをZZ
      current_tags = self.tags.pluck(:tag_name)
    end
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    # 古いタグの削除
    old_tags.each do |old_tag|
      self.tags.delete(Tag.find_by(name: old_tag))
    end
    # 新しいタグの保存
    new_tags.each do |new_tag|
      tag = Tag.find_or_create_by(name: new_tag)
      maps = ReviewTagMap.find_or_create_by(review_id: self.id, tag_id: tag.id)
      self.review_tag_maps.push(maps)
      # pushメソッド = 追加で保存する
      # a="1"  a.push("2")  a= "1", "2"
      #self.tags.push(review_tag_map)
    end
  end


end
