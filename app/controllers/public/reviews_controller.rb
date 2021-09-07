class Public::ReviewsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end
  
  def confirm
    @review = Review.new(review_params)
  endgit 

  def create
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.product_id = @product.id
    if @review.save
      redirect_to product_path(@product.id), notice: "レビューを投稿しました"
    else
      flash.now[:alert] = "レビューの投稿に失敗しました"
      redirect_to new_product_review_path
      @review = Review.new(review_params)
    end
  end

  def destroy
    @product = Product.find(params[:priduct_id])
    Review.find_by(id: params[:id], product_id: params[:product_id]).destroy
  end

  private

  def review_params
      params.require(:review).permit(:comment, :evaluation)
  end

end
