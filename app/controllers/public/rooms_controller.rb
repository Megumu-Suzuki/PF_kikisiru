class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

	def create
	  @room = Room.create(user_id: current_user)
		@current_user_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
		@user_entry = Entry.create(join_room_params)
		redirect_to room_path(@room.id)
	end

	def show
		@room = Room.find(params[:id])
		@room.check_messages_notification(current_user)
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
    	user_id = @room.entries.where.not(user_id: current_user.id).select(:user_id)
    	@user = User.find_by(id: user_id)
      @direct_messages = @room.direct_messages
      @direct_message = DirectMessage.new
      @entries = @room.entries
    else
      redirect_to root_path, notice: "アクセス権限がありません"
    end
	end

	private

	def join_room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
	end

end

