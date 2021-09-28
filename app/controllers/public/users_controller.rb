class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @products = Product.where(user_id: params[:id]).includes([:reviews]).sort { |a, b| b.id <=> a.id }
    @products = Kaminari.paginate_array(@products).page(params[:page]).per(5)
    if user_signed_in?
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
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user), notice: "編集権限がありません"
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: '会員情報を変更しました'
    else
      render :edit
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

  def favorite
    @user = User.find(params[:id])
    @favorites = @user.favorites.sort { |a, b| b.id <=> a.id }
    @favorites = Kaminari.paginate_array(@favorites).page(params[:page]).per(5)
    if user_signed_in?
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
    end
  end

  def review
    @user = User.find(params[:id])
    @reviews = @user.reviews.sort { |a, b| b.id <=> a.id }
    @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(5)
    if user_signed_in?
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
    end
  end

  def room
    # ログインユーザーが持っているentryのroom_idを取得
    my_room_ids = current_user.entries.select(:room_id)
    # entryからroom_idがmy_rooms_idsと一致し、user_idがcurrent_user_idではないものを取得
    @entries = Entry.includes(:user).where(room_id: my_room_ids).
      where.not(user_id: current_user.id).reverse_order
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana,
                                 :nickname, :phone_number, :email, :profile_image)
  end
end
