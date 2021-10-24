class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @contact_messages = ContactMessage.where(admin_id: nil).sort { |a, b| b.created_at <=> a.id }
    @contact_messages = Kaminari.paginate_array(@contact_messages).page(params[:page]).per(5)
  end
end

