class Public::UsersController < ApplicationController

  def show
    @user = User.find_by(params[:id])
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
  
  def product
    @products = Product.where(usre_id: params[:id])
  end

  def favorite
    @favorites = Favorite.where(user_id: params[:id])
  end

  def review
    @reviews = Review.where(user_id: params[:id])
  end

  def room
    @rooms = Room.where(user_id: current_user)
  end

  private
    def user_params
      params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :nickname, :phone_number, :email)
    end
end
