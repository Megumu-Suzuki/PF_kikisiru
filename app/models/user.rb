class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # プロフィール画像
  has_one_attached :profile_image
  # 商品機能
  has_many :products, dependent: :destroy
  # レビュー機能
  has_many :reviews, dependent: :destroy
  has_many :review_products, through: :reviews, source: :product
  # いいね機能
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  # チャット機能
  has_many :direct_messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  # チャット一覧
  has_many :rooms, through: :entries, source: :room
  # 問い合わせ機能
  has_many :contacts, dependent: :destroy
  has_many :contact_messages, dependent: :destroy
  # 通知機能
  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id'
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id'

  validates :last_name, :first_name, :last_name_kana,
            :first_name_kana, presence: true, length: { maximum: 15 }
  validates :nickname, allow_blank: true, length: { in: 1..15 }
  validates :email, length: { maximum: 50 }
  validates :phone_number, allow_blank: true,
                           numericality: { only_integer: true },
                           length: { in: 10..11 }

  def full_name
    last_name + " " + first_name
  end

  # 未読のメッセージが存在するか確認
  def unchecked_message?
    # Entryで指定のユーザーidをを持つもののroom_idの情報
    my_room_ids = Entry.select(:room_id).where(user_id: id)
    # Entryでmy_room_idsを持ちユーザーidが指定のユーザーidでないもののユーザー情報
    other_user_ids = Entry.select(:user_id).where(room_id: my_room_ids).where.not(user_id: id)
    # 指定の条件下でis_checkedがfalse(=未読)のものがあるか（.any? あったらtrue）
    DirectMessage.where(user_id: other_user_ids, room_id: my_room_ids, is_checked: false).any?
  end
end
