class Contact < ApplicationRecord
  belongs_to :user, optional: true
  has_many :contact_messages, dependent: :destroy
  
  validates :user_id, :is_completed, presence: true
end
