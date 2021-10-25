class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @product = Product.new
    @tags = Tag.all
    @genres = Genre.all
  end

  def create
    @product = Product.new(product_params)
    tag_list = params[:product][:name].split(",")
    if @product.save(product_params)
      @product.save_tag(tag_list)
      redirect_to admin_product_path(@product.id)
    else
      @tags = Tag.all
      @genres = Genre.all
      render :new and return
    end
  end

  def index
    @products = Product.all.includes([:genre]).page(params[:page]).per(20)
  end

  def show
    @product = Product.find(params[:id])
    @reviews = Review.where(product_id: @product.id).includes([:user])
    @reviews = Kaminari.paginate_array(@reviews).page(params[:page]).per(5)
    @all_images = @product.product_all_images
    @all_images = Kaminari.paginate_array(@all_images).page(params[:page]).per(18)
  end

  def edit
    @product = Product.find(params[:id])
    @genres = Genre.all
    @tag_list = @product.tags.pluck(:name).join(",")
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
      redirect_to admin_product_path(@product.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      @genres = Genre.all
      render :edit
    end
  end

  def update_image
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_product_path(@product.id), notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit_image
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path
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
