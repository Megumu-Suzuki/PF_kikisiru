class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @contact_messages = ContactMessage.all
  end

end
