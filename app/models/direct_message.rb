class DirectMessage < ApplicationRecord
	# たくさんのメッセージそれぞれにユーザーIDとルームのID
	belongs_to :user
	belongs_to :room
	# 空白のメッセージは送れない
	validates :user_id, :room_id, presence: true
	validates :message, presence: true, length: { maximum: 140 }
	
	# 通知機能
	def create_notification_direct_message(current_user, direct_message_id, room_id, visited_id)
		# チャットしている相手を取得し通知を送る
		temp_ids = DirectMessage.select(:user_id).where(room_id: room_id).where.not(user_id: current_user.id).distinct
		temp_ids.each do |temp_id|
			save_notification_chat(current_user, direct_message_id, temp_id['user_id'])
		end
		# チャットが空の時、送信者に通知を送る
		save_notification_chat(current_user, direct_message_id, visited_id) if temp_ids.blank?
	end
	
	def save_notification_chat(current_user, message_id, visited_id)
		notification = current_user.active_notifications.new(
			direct_message_id: direct_message_id,
			visited_id: visited_id,
		)
		if notification.visitor_id == notification.visited_id
			notification.is_checked = true
		end
		notification.save if notification.valid?
	end
	
end
