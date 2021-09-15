class Public::ContactsController < ApplicationController

  def index
    if current_user.nil?
      @contact = Contact.new
      @contact_message = ContactMessage.new
      @user_contact = nil
    else
      @user_contact = Contact.find_by(user_id: current_user.id, is_completed: "false")
      if @user_contact.present?
        @contact_messages = ContactMessage.where(user_id: current_user.id)
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
    else
      @contact = Contact.create(contact_params)
    end
    @contact_message = ContactMessage.create(contact_message_params)
    redirect_to thanx_contacts_path
    #else
    #  flash.now[:alert] = "送信に失敗しました"
    #  redirect_to contacts_path
    #  @product = Product.new(contact_params)
    # end
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