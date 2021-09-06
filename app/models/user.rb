class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #プロフィール画像
  has_one_attached :profile_image
  has_many :products, dependent: :destroy
  
  def full_name
    "#{last_name} #{first_name}"
  end
end
