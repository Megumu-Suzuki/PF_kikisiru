class Public::ProductsController < ApplicationController

  def new
    @product = Product.new
    @genres = Genre.all
  end

  def confirm
    @product = Product.new(product_params)
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

  #商品タグ、画像登録ページ
  def image
    @product = Product.find(params[:id])
    @product_images = @product.product_images.build
  end

  #タグ、商品画像登録
  def addition
    @product = Product.find(params[:id])
    tag_list = params[:product][:name].split(",")
    if @product.update(product_params)
      @product.save_tag(tag_list)
      redirect_to product_path(@product.id), notice: "画像を登録しました"
    else
      flash.now[:alert] = "画像の登録に失敗しました"
      redirect_to image_product_path(@product.id)
      @product = Product.find(params[:id])
      @product.product_images.new
    end
  end

  def show
    @product = Product.find(params[:id])
    @reviews = Review.where(product_id: @product.id)
    # 商品についているタグ情報
    @product_tags = Tag.joins(:product_tag_maps).where(product_tag_maps: {product_id: @product.id})
    # レビューについておるタグ情報
    @review_tags = Tag.joins(:review_tag_maps).where(review_tag_maps: {review_id: @reviews.pluck(:id)})
    # 商品とレビューのタグ情報を合わせる
    @tags = @product_tags + @review_tags
    # 被っているタグを削除
    @tags_all = @tags.uniq
    if @product.reviews.blank?
      @average_review = 0
    else
      @average_review = @product.review_average.round(1)
    end
  end

  def edit
    @target = params["target"]
    if @target == "image"
      @product = Product.find(params[:id])
      #@product_images = ProductImage.where(product_id: @product.id)
    else
      @product = Product.find(params[:id])
      @genres = Genre.all
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:user_id, :genre_id, :title, :description, :model, :price, :manufacture, :width, :depth, :height, :weight, :phase, :power_consumption, :city_gas, :propane_gas, :allow_edit, :image, product_images_attributes: [:images, :description])
  end

end
