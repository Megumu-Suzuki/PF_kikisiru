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
    @product.user_id = current_user.id
    if @product.save
      redirect_to product_path(@product.id), notice: "商品を追加しました"
    else
      flash.now[:alert] = "商品の追加に失敗しました"
      redirect_to new_product_path
      @product = Product.new(product_params)
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  private

  def product_params
    params.require(:product).permit(:user_id, :genre_id, :title, :description, :model, :price, :manufacture, :width, :depth, :height, :weight, :phase, :power_consumption, :city_gas, :propane_gas, :allow_edit, product_images_attributes: [:image, :description])
  end

end
