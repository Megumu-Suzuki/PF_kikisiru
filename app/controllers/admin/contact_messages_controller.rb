class Admin::ContactMessagesController < ApplicationController
  
  def create
    @contact_message = ContactMessage.create(contact_message_params)
  end
  
  
  private
  
  def contact_message_params
    params.require(:contact_message).permit(:admin_id, :contact_id, :name, :email, :subject, :body)
  end
  
end
