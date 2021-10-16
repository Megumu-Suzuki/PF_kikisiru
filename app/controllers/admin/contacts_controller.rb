class Admin::ContactsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @contact = Contact.find(params[:id])
    @contact_messages = ContactMessage.find_by(contact_id: params[:id], admin_id: nil)
    @admin_messages = ContactMessage.where(contact_id: params[:id], admin_id: present?)
    @contact_message = ContactMessage.new
  end

  def completed
    @contact = Contact.find(params[:id])
    @contact.update(is_completed: true)
    redirect_to admin_path
  end
end
