class Public::ReviewsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def confirm
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find(params[:product_id])
    @review.user_id = current_user.id
    @review.product_id = @product.id
    render :new and return if params[:return]
    if @review.save
      redirect_to image_product_review_path(@product.id, @review.id), notice: "レビューを投稿しました"
    else
      flash.now[:alert] = "レビューの投稿に失敗しました"
      redirect_to new_product_review_path
      @review = Review.new(review_params)
    end
  end
  #レビュータグ、画像登録ページ
  def image
    @review = Review.find(params[:id])
    @review_images = @review.review_images.build
  end
  #レビュータグ、画像登録
  def addition
    @review = Review.find(params[:id])
    @product = @review.product.id
    tag_list = params[:review][:name].split(",")
    if @review.update(review_params)
      @review.save_tag(tag_list)
      redirect_to product_review_path(@review.product.id, @review.id), notice: "画像を登録しました"
    else
      flash.now[:alert] = "画像の登録に失敗しました"
      redirect_to image_product_review_path(@review.product.id, @review.id)
      @review = Review.find(params[:id])
      @review.review_images.new
    end
  end

  def show
    @review = Review.find(params[:id])
    @user = @review.user
    @product = @review.product
    @reviews = Review.where(product_id: @product.id)
  end

  def edit
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
  end

  def update
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to product_review_path(@review.product.id, @review.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      @product = Product.find(params[:product_id])
      @review = Review.find(params[:id])
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:product_id])
    if Review.find_by(id: params[:id], product_id: params[:product_id]).destroy
      redirect_to product_path(@product.id), notice: "レビューを削除しました"
    else
      flash.now[:alert] = "レビューの削除に失敗しました"
      render :edit
    end
  end

  private

  def review_params
      params.require(:review).permit(:title, :comment, :evaluation, review_images_attributes: [:images, :description])
  end

end
