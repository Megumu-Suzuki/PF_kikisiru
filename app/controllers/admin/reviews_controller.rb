class Admin::ReviewsController < ApplicationController

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @product = @review.product
    @reviews = Review.where(product_id: @product.id)
  end

  def destroy
    @product = Product.find(params[:product_id])
    if Review.find_by(id: params[:id], product_id: params[:product_id]).destroy
      redirect_to admin_product_path(@product.id), notice: "レビューを削除しました"
    else
      flash.now[:alert] = "レビューの削除に失敗しました"
      render :edit
    end
  end
end
