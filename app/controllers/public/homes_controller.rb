class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all
    @tags = Tag.all
    @product_ranking = Product.left_joins(:reviews).distinct.sort_by do |product|
      ranking = product.reviews
      if ranking.present?
        ranking.map(&:evaluation).sum / ranking.size
      else
        0
      end
    end.reverse
  end

  def about
  end

end
