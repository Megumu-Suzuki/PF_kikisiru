class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    #@room_recevier.id = @user.id
    #チャット機能
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @have_room = true
            @room_id = cu.room_id
          end
        end
      end
      unless @have_room
				@room = Room.new
				@entry = Entry.new
      end
    end
    @products = Product.where(user_id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path(current_user), notice: '会員情報を変更しました'
    else
      flash.now[:alert] = "会員情報を変更できませんでした"
      redirect_to request.referer
    end
  end

  def unsubscribe
  end

  def withdraw
    @user = current_user
    @user.update(is_deleted: false)
    reset_session
    redirect_to root_path, notice: "退会しました"
  end

  def product
    @user = User.find(params[:id])
    @products = Product.where(user_id: params[:id])
  end

  def favorite
    @user = User.find_by(id: params[:id])
    @favorites = Favorite.where(user_id: params[:id])
  end

  def review
    @user = User.find_by(id: params[:id])
    @reviews = Review.where(user_id: params[:id])
  end

  def room
    @entries = Entry.where(user_id: current_user.id)
    @entries.each do |entry|
      @another_entries = Entry.where(room_id: entry.room.id).where.not(user_id: current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :phone_number, :email, :profile_image)
  end

end
