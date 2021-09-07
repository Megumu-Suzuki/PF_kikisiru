class Public::FavoritesController < ApplicationController
  
  def create
    @product = Product.find(params[:product_id])
    favorite = current_user.favorites.build(product_id: @product.id)
    # @user = favorite.user
    # この定義だといいねした人＝他人のページでも数値が増える
    favorite.save
  end

  def destroy
    @product = Product.find(params[:product_id])
    favorite = current_user.favorites.find_by(product_id: @product.id)
    # @user = favorite.user
    favorite.destroy
  end
  
end
