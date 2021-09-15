class Admin::ProductsController < ApplicationController

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
      flash.now[:alert] = "内容に不備があります"
      @product = Product.new(product_params)
      @tags = Tag.all
      @genres = Genre.all
      render :new and return
    end
  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @reviews = Review.where(product_id: @product.id)
    @product_tags = Tag.joins(:product_tag_maps).where(product_tag_maps: {product_id: @product.id})
    @review_tags = Tag.joins(:review_tag_maps).where(review_tag_maps: {review_id: @reviews.pluck(:id)})
    @tags = @product_tags | @review_tags
    @tags_all = @tags.uniq
    if @product.reviews.blank?
      @average_review = 0
    else
      @average_review = @product.review_average.round(1)
    end
  end

  def edit
    @product = Product.find(params[:id])
    @genres = Genre.all
  end

  def update
    @product = Product.find(params[:id])
    if params[:product][:delete].present?
      @product.top_image.purge
      redirect_back(fallback_location: root_path)
    else
      if @product.update(product_params)
        redirect_to admin_product_path(@product.id), notice: "変更を保存しました"
      else
        flash.now[:alert] = "変更の保存に失敗しました"
        @genres = Genre.all
        render :edit
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:user_id, :genre_id, :title, :description, :model, :price, :manufacture, :width, :depth, :height, :weight, :phase, :power_consumption, :city_gas, :propane_gas, :allow_edit, :top_image, product_images_attributes: [:images, :description])
  end

end
