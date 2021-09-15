class Entry < ApplicationRecord
  # 複数の参加者一人一人にユーザーIDとルーム
	belongs_to :user
	belongs_to :room
	
	validates :user_id, :room_id, presence :true
end
