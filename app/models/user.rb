class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #プロフィール画像
  has_one_attached :profile_image
  #商品機能
  has_many :products, dependent: :destroy
  #レビュー機能
  has_many :reviews, dependent: :destroy
  #いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :book

  def full_name
    self.last_name + " " + self.first_name
  end
end
