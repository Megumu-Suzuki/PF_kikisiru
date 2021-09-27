class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @product = @review.product
    @reviews = Review.where(product_id: @product.id).sort { |a, b| b.created_at <=> a.id }
    @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(5)
    @review_images = @review.review_images.page(params[:page]).per(5)
  end

  def destroy
    @product = Product.find(params[:product_id])
    if Review.find(params[:id]).destroy
      redirect_to admin_product_path(@product.id), notice: "レビューを削除しました"
    else
      flash.now[:alert] = "レビューの削除に失敗しました"
      render :edit
    end
  end
end
