class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all
    @tags = Tag.limit(20).order("id DESC")
    @genre_rankings = @genres.each do |genre|
      Product.left_joins(:reviews).where(genre_id: genre.id).distinct.sort_by do |product|
        ranking = product.reviews
        if ranking.present?
          ranking.map(&:evaluation).sum / ranking.size
        else
          0
        end
      end.reverse
    end
    @product_image = @genre_rankings
  end

  def about
  end

end
