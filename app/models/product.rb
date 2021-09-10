class Product < ApplicationRecord

  belongs_to :user
  #商品画像
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  #いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  #レビュー機能
  has_many :reviews, dependent: :destroy
  #タグ機能
  has_many :product_tag_maps, dependent: :destroy
  has_many :tags, through: :product_tag_maps



  #すでにお気に入りされているかどうかを判定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_tag(sent_tags)
    unless self.tags.nil?
      # pluckメソッド = テーブルから指定のカラムのデータを持ってくる
      current_tags = self.tags.pluck(:name)
    end
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    # 古いタグの削除
    old_tags.each do |old_tag|
      self.tags.delete
      Tag.find_by(name: old_tag)
    end
    # 新しいタグの保存
    new_tags.each do |new_tag|
      product_tag_map = Tag.find_or_create_by(name: new_tag)
      # pushメソッド = 追加で保存する
      # a="1"  a.push("2")  a= "1", "2"
      self.tags.push(product_tag_map)
    end
  end


  enum manufacture: { "A社": 0, "B社": 1, "C社": 2, "D社": 3, "E社": 4, "その他": 5}
  enum phase: { "1φ100V": 0, "1φ200V": 1, "3φ200V": 2}

end
