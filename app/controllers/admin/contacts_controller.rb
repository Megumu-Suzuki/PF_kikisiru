class Admin::ContactsController < ApplicationController

  def show
    @contact_message = ContactMessage.find(params[:id])
  end
end
