class Entry < ApplicationRecord
  # 複数の参加者一人一人にユーザーIDとルーム
	belongs_to :user
	belongs_to :room
	has_many :direct_messages, through: :room

	validates :user_id, :room_id, presence: true

	# roomに未読のメッセージがあるか確認
	def check_message
		direct_messages.where(user_id: user.id, is_checked: false).any?
	end

end
