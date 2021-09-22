class Contact < ApplicationRecord
  belongs_to :user, optional: true
  has_many :contact_messages, dependent: :destroy

end
