class Product < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :model, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, :width, :height, :weight, :power_consumption, :city_gas,
            :propane_gas, allow_nil: true, numericality: { only_float: true }
  validate :image_presence, on: :update

  belongs_to :user, optional: true
  belongs_to :genre
  # 機器画像
  has_one_attached :top_image
  has_many :product_images, dependent: :destroy
  accepts_nested_attributes_for :product_images, allow_destroy: true
  # いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  # レビュー機能
  has_many :reviews, dependent: :destroy
  # タグ機能
  has_many :product_tag_maps, dependent: :destroy
  has_many :tags, through: :product_tag_maps

  def image_presence
    unless top_image.attached?
      errors.add(:top_image, '画像を添付してください')
    end
  end

  # すでにお気に入りされているかどうかを判定
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def save_tag(sent_tags)
    # pluckメソッド = テーブルから指定のカラムのデータを持ってくる
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
      maps = ProductTagMap.find_or_create_by(product_id: id, tag_id: tag.id)
      # pushメソッド = 追加で保存する
      # a="1"  a.push("2")  a= "1", "2"
      product_tag_maps.push(maps)
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

  # 機器のサイズの定義
  def product_size
    if width.present?
      if depth.present?
        if height.present?
          width.to_s + " × " + depth.to_s + " × " + height.to_s + " mm"
        else
          width.to_s + " × " + depth.to_s + " mm"
        end
      elsif height.present?
        width.to_s + " × " + height.to_s + " mm"
      end
    elsif depth.present? && height.present?
      depth.to_s + " × " + height.to_s + " mm"
    else
      "- mm"
    end
  end

  # 機器のサイズの単位の定義
  def product_size_unit
    if width.present?
      if depth.present?
        if height.present?
          "(間口×奥行×高さ)"
        else
          "(間口×奥行)"
        end
      elsif height.present?
        "(間口×高さ)"
      end
    elsif depth.present? && height.present?
      "(奥行×高さ)"
    end
  end

  # 機器と機器のレビューについてるタグを機器のタグとする定義
  def product_tags
    @reviews = Review.where(product_id: id)
    # 機器についているタグ情報
    @product_tags = Tag.joins(:product_tag_maps).where(product_tag_maps: { product_id: id })
    # レビューについておるタグ情報
    @review_tags = Tag.joins(:review_tag_maps).where(review_tag_maps: { review_id: @reviews.pluck(:id) })
    # 機器とレビューのタグ情報を合わせる
    @tags = @product_tags + @review_tags
    # 被っているタグを削除
    @tags_all = @tags.uniq
  end

  # 機器と機器のレビューについている画像全ての定義
  def product_all_images
    # 機器の画像全て
    @product_images = product_images

    if reviews.present?
      # レビューの画像全て
      @review_images = ReviewImage.joins(:review).where(reviews: { product_id: id })
      # 機器の画像の全てとレビューの画像の全てを合計
      @all_images = @product_images | @review_images
    else
      @all_images = @product_images
    end
  end

  enum manufacture: { "A社": 0, "B社": 1, "C社": 2, "D社": 3, "E社": 4, "その他": 5 }
  enum phase: { "1φ100V": 0, "1φ200V": 1, "3φ200V": 2 }
end
