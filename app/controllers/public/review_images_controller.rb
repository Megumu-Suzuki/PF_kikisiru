class Public::ReviewImagesController < ApplicationController

  def update
    @review_image = ReviewImage.find(params[:id])
    @review_image.update(image_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @review_image = ReviewImage.find(params[:id])
    @review_image.images.purge
    @review_image.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def image_params
    params.require(:review_image).permit(:description)
  end

end
