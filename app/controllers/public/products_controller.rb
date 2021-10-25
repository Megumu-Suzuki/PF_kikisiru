class Public::ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @product = Product.new
    @genres = Genre.all
  end

  def index
    # confirm画面から戻るボタンを押し遷移した先でリロードした時のエラー
    redirect_to new_product_path, notice: "機器を投稿しました"
  end

  def confirm
    # getでリクエストされた時にnewページに遷移するように設定
    redirect_to new_product_path, notice: "機器を投稿しました" and return if request.get?
    @product = Product.new(product_params)
    unless @product.valid?
      @genres = Genre.all
      render :index and return
    end
  end

  def create
    @product = Product.new(product_params)
    @genres = Genre.all
    render :new and return if params[:back]
    @product.user_id = current_user.id
    if @product.save
      redirect_to image_product_path(@product.id), notice: "機器を投稿しました"
    else
      flash.now[:alert] = "機器の投稿に失敗しました"
      redirect_to new_product_path
      @product = Product.new(product_params)
    end
  end

  # 商品タグ、画像登録ページ
  def image
    @product = Product.find(params[:id])
    @product_images = @product.product_images.build
  end

  # タグ、商品画像登録
  def addition
    @product = Product.find(params[:id])
    tag_list = params[:product][:name].split(",")
    if @product.update(product_params)
      @product.save_tag(tag_list)
      redirect_to product_path(@product.id), notice: "画像を登録しました"
    else
      redirect_to image_product_path(@product.id), notice: "内容に不備があります"
      @product = Product.find(params[:id])
      @product.product_images.new
    end
  end

  def show
    @product = Product.find(params[:id])
    @positive_reviews = Review.where(product_id: @product.id, score: 0.4..1).sort { |a, b| b.created_at <=> a.id }
    @neutral_reviews = Review.where(product_id: @product.id, score: -0.3..0.3).sort { |a, b| b.created_at <=> a.id }
    @negative_reviews = Review.where(product_id: @product.id, score: -1..-0.4).sort { |a, b| b.created_at <=> a.id }
    if @product.reviews.blank?
      @average_review = 0
    else
      @average_review = @product.review_average.round(1)
    end
    @all_images = @product.product_all_images
    @all_images = Kaminari.paginate_array(@all_images).page(params[:page]).per(18)
  end

  def edit
    @product = Product.find(params[:id])
    if @product.allow_edit == true
      @genres = Genre.all
      @tag_list = @product.tags.pluck(:name).join(",")
    elsif @product.allow_edit == false && @product.user == current_user
      @genres = Genre.all
      @tag_list = @product.tags.pluck(:name).join(",")
    else
      redirect_to product_path(@product.id), notice: "編集権限がありません"
    end
  end

  def edit_image
    @product = Product.find(params[:id])
    @product_image = ProductImage.new
  end

  def update
    @product = Product.find(params[:id])
    tag_list = params[:product][:name].split(",")
    if @product.update(product_params)
      @product.save_tag(tag_list)
      redirect_to product_path(@product.id), notice: "変更を保存しました"
    else
      @genres = Genre.all
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit
    end
  end

  def update_image
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit_image
    end
  end

  private

  def product_params
    params.require(:product).permit(:user_id, :genre_id, :title, :description, :model, :price,
                                    :manufacture, :width, :depth, :height, :weight,
                                    :phase, :power_consumption, :city_gas,
                                    :propane_gas, :allow_edit, :top_image,
                                    product_images_attributes: [:images, :description])
  end
end
