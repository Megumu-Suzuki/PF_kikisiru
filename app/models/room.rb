class Room < ApplicationRecord
  # 一つのルームにたくさんのメッセージ
	has_many :direct_messages, dependent: :destroy
	# 一つのルームに複数（二人）の
	has_many :entries, dependent: :destroy
	
	has_many :users, through: :entries, source: :user 
end
