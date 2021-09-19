class Product < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :genre
  #商品画像
  has_one_attached :top_image
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  #いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  #レビュー機能
  has_many :reviews, dependent: :destroy
  #タグ機能
  has_many :product_tag_maps, dependent: :destroy
  has_many :tags, through: :product_tag_maps, source: :product

  validate :image_presence, on: :update
  validates :genre_id, :description, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :model, presence: true, uniqueness: true
  validates :price, :width, :height, :power_consumption, :city_gas, :propane_gas, allow_nil: true, numericality: {only_float: true}


  def image_presence
    unless top_image.attached?
      errors.add(:top_image, '画像を添付してください')
    end
  end



  #すでにお気に入りされているかどうかを判定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_tag(sent_tags)
    # pluckメソッド = テーブルから指定のカラムのデータを持ってくる
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    # 古いタグの削除
    old_tags.each do |old_tag|
      self.tags.delete(Tag.find_by(name: old_tag))
    end
    # 新しいタグの保存
    new_tags.each do |new_tag|
      tag = Tag.find_or_create_by(name: new_tag)
      maps = ProductTagMap.find_or_create_by(product_id: self.id, tag_id: tag.id)
      # pushメソッド = 追加で保存する
      # a="1"  a.push("2")  a= "1", "2"
      self.product_tag_maps.push(maps)
    end
  end
  
  # 評価の平均点
  def review_average
    if self.reviews.present?
      self.reviews.map(&:evaluation).sum / self.reviews.size
    else
      0
    end
  end

  # 機器名と型式
  def full_name
    self.title + "(" + self.model + ")"
  end
  
  # 機器のサイズの定義
  def product_size
    if self.width.present?
      if self.depth.present?
        if self.height.present?
          self.width.to_s + " × " + self.depth.to_s + " × " + self.height.to_s + " mm"
        else
          self.width.to_s + " × " + self.depth.to_s+ " mm"
        end
      elsif self.height.present?
        self.width.to_s + " × " + self.height.to_s+ " mm"
      end
    elsif self.depth.present? && self.height.present?
      self.depth.to_s + " × " + self.height.to_s+ " mm"
    end
  end
  # 機器のサイズの単位の定義
  def product_size_unit
    if self.width.present?
      if self.depth.present?
        if self.height.present?
          "(間口×奥行×高さ)"
        else
          "(間口×奥行)"
        end
      elsif self.height.present?
        "(間口×高さ)"
      end
    elsif self.depth.present? && self.height.present?
      "(奥行×高さ)"
    end
  end

  # 機器と機器のレビューについてるタグを機器のタグとする定義
  def product_tags
    @reviews = Review.where(product_id: self.id)
    # 機器についているタグ情報
    @product_tags = Tag.joins(:product_tag_maps).where(product_tag_maps: {product_id: self.id})
    # レビューについておるタグ情報
    @review_tags = Tag.joins(:review_tag_maps).where(review_tag_maps: {review_id: @reviews.pluck(:id)})
    # 機器とレビューのタグ情報を合わせる
    @tags = @product_tags + @review_tags
    # 被っているタグを削除
    @tags_all = @tags.uniq
  end




  enum manufacture: { "A社": 0, "B社": 1, "C社": 2, "D社": 3, "E社": 4, "その他": 5}
  enum phase: { "1φ100V": 0, "1φ200V": 1, "3φ200V": 2}

end
