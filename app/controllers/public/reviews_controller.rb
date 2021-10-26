class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def index
    @product = Product.find(params[:product_id])
    @status = params["status"]
    if @status == "positive"
      @reviews = Review.where(product_id: @product.id, score: 0.4..1).sort { |a, b| b.created_at <=> a.id }
    elsif @status == "neutral"
      @reviews = Review.where(product_id: @product.id, score: -0.3..0.3).sort { |a, b| b.created_at <=> a.id }
    elsif @status == "negative"
      @reviews = Review.where(product_id: @product.id, score: -1..-0.4).sort { |a, b| b.created_at <=> a.id }
    else
      @reviews = Review.where(product_id: @product.id).sort { |a, b| b.created_at <=> a.id }
    end
    @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(10)
  end

  def confirm
    redirect_to new_product_review_path, notice: "正常な処理がされなかったので終了しました" and return if request.get?
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
    unless @review.valid?
      render :index
    end
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find(params[:product_id])
    @review.user_id = current_user.id
    @review.product_id = @product.id
    render :new and return if params[:return]
    @review.score = Language.get_data(review_params[:comment])
    if @review.save
      redirect_to image_product_review_path(@product.id, @review.id), notice: "レビューを投稿しました"
    else
      flash.now[:alert] = "レビューの投稿に失敗しました"
      redirect_to product_reviews_path
      @review = Review.new(review_params)
    end
  end

  # レビュータグ、画像登録ページ
  def image
    @review = Review.find(params[:id])
    @review_images = @review.review_images.build
  end

  # レビュータグ、画像登録
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
    @reviews = Review.where(product_id: @product.id).sort { |a, b| b.created_at <=> a.id }
    @review_images = @review.review_images.page(params[:page]).per(5)
  end

  def edit
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    @user = @review.user
    if @user.id == current_user.id
      @tag_list = @review.tags.pluck(:name).join(",")
    else
      redirect_to product_review_path(@review.product.id, @review.id), notice: "編集権限がありません"
    end
  end

  def edit_image
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    @user = @review.user
    if @user.id == current_user.id
      @review_image = ReviewImage.new
    else
      redirect_to product_review_path(@review.product.id, @review.id), notice: "編集権限がありません"
    end
  end

  def update
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    tag_list = params[:review][:name].split(",")
     @review.score = Language.get_data(review_params[:comment])
    if @review.update(review_params)
      @review.save_tag(tag_list)
      redirect_to product_review_path(@review.product.id, @review.id), notice: "変更を保存しました"
    else
      @tag_list = @review.tags.pluck(:name).join(",")
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit
    end
  end

  def update_image
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to product_review_path(@review.product.id, @review.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit_image
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
    params.require(:review).permit(:user_id, :product_id, :title, :comment, :evaluation,
                                   review_images_attributes: [:images, :description])
  end
end
