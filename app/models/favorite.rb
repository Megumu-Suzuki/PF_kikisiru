class Favorite < ApplicationRecord

  belongs_to :user
	belongs_to :product
  #本一つにユーザーは一人だけ（複数回のいいねを防ぐ）
	validates_uniqueness_of :product_id, scope: :user_id

end
