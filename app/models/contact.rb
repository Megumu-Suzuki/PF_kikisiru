class Contact < ApplicationRecord
  belongs_to :user
  has_many :contact_messages, dependent: :destroy
end
