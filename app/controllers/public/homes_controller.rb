class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all.includes(:products)
    @tags = Tag.limit(20).order("id DESC")
    @genre_rankings = @genres.each do |genre|
      genre.products.sort_by do |product|
        product.review_average
      end.reverse
    end
  end

end
