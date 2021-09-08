class DirectMessage < ApplicationRecord
  # 空白のメッセージは送れない
	#validates :content, presence:true, length: { maximum: 140 }
	# たくさんのメッセージそれぞれにユーザーIDとルームのID
	belongs_to :user
	belongs_to :room
end
