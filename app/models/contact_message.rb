class ContactMessage < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin, optional: true
  belongs_to :contact
  
  validates :contact_id, :name, :email, :subject, :body, presence: true
  
end
