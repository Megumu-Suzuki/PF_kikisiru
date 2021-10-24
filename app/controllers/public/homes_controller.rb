class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all.includes(:products)
    @tags = Tag.limit(20).order("id DESC")
    @genre_rankings = []
    @genres.each do |genre|
      @genre_rankings << Product.where(genre_id: genre.id).sort_by do |product|
        if product.reviews.average(:evaluation).nil?
          0
        else
          product.reviews.average(:evaluation) * 10
        end
      end.reverse.take(5) #5件分取得
    end
  end

  def about
    @genres = Genre.all.includes(:products)
    @tags = Tag.limit(20).order("id DESC")
    @genre_rankings = []
    @genres.each do |genre|
      @genre_rankings << Product.where(genre_id: genre.id).sort_by do |product|
        if product.reviews.average(:evaluation).nil?
          0
        else
          product.reviews.average(:evaluation) * 10
        end
      end.reverse.take(5) #5件分取得
    end
  end

end
