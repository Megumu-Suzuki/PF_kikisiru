class Admin::ProductImagesController < ApplicationController

  def update
    @product_image = ProductImage.find(params[:id])
    @product_image.update(image_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @product_image = ProductImage.find(params[:id])
    @product_image.images.purge
    @product_image.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def image_params
    params.require(:product_image).permit(:description)
  end

end
