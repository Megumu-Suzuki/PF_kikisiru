class Public::ContactsController < ApplicationController

  def index
    if current_user.nil?
      @contact = Contact.new
      @contact_message = ContactMessage.new
      @user_contact = nil
    else
      @user_contact = Contact.find_by(user_id: current_user.id, is_completed: "false")
      if @user_contact.present?
        @contact_messages = ContactMessage.where(user_id: current_user.id, contact_id: @user_contact.id)
        @admin_messages = ContactMessage.where(user_id: nil, contact_id: @user_contact.id)
        @contact_message = ContactMessage.new
      else
        @contact = Contact.new
        @contact_message = ContactMessage.new
      end
    end
  end

  def confirm
    @contact = Contact.new
    @contact_message = ContactMessage.new(contact_message_params)
    unless @contact_message.valid?
      render :index and return
    end
  end

  def create
    @contact = Contact.new
    @contact_message = ContactMessage.new(contact_message_params)
    if current_user.nil?
      @user_contact = nil
    else
      @user_contact = Contact.find_by(user_id: current_user.id, is_completed: "false")
    end
    render :index and return if params[:back]
    if current_user.nil?
      @contact = Contact.create
      @contact_message = ContactMessage.create(contact_message_params)
      unless @contact_message.valid?
        @contact = Contact.new
        @contact_message = ContactMessage.new(contact_message_params)
        render :index and return
      end
    else
      @contact = Contact.create(contact_params)
      @contact_message = ContactMessage.create(contact_message_params)
      unless @contact_message.valid?
        @contact = Contact.new
        @contact_message = ContactMessage.new(contact_message_params)
        render :index and return
      end
    end
    redirect_to thanx_contacts_path
  end


  def thanx
  end

  private

  def contact_params
    params.require(:contact).permit(:user_id)
  end

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :body, :user_id).merge(contact_id: @contact.id)
  end

end