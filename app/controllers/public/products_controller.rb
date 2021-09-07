class Public::ProductsController < ApplicationController

  def new
    @product = Product.new
    @product.product_images.new
  end

  def confirm
    @product = Product.new(product_params)
  end

  def create
    @product = Product.new(product_params)
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

  def image
    @product = Product.find(params[:id])
    @product.product_images.new
  end

  def addition
    @product = Product.find(params[:id])
    if @product.update(product_params)
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
  end

  def edit
    @product = Product.find(params[:id])
    unless ProductImage.exists?(product_id: @product.id)
      @product.product_images.new
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
    params.require(:product).permit(:user_id, :genre_id, :title, :description, :model, :price, :manufacture, :width, :depth, :height, :weight, :phase, :power_consumption, :city_gas, :propane_gas, :allow_edit, product_images_attributes: [:images, :description])
  end

end
