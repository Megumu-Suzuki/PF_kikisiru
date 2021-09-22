class Room < ApplicationRecord
  # 一つのルームにたくさんのメッセージ
	has_many :direct_messages, dependent: :destroy
	# 一つのルームに複数（二人）の
	has_many :entries, dependent: :destroy

	has_many :users, through: :entries, source: :user

	# チャットの通知を既読にするためのメソッド
	def check_messages_notification(current_user)
		unchecked_messages = DirectMessage.includes(:user).where(is_checked: false).where.not(user_id: current_user.id)
		# &. データがnilの時のエラーを防止してくれる
		unchecked_messages&.each {|unchecked_message| unchecked_message.update(is_checked: true) }
	end
end
