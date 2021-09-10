class Public::SearchesController < ApplicationController

  def search
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    @datas = search_for(@model, @value)
    @genres = Genre.all
    @tags = Tag.all
  end

  private

  def product(value)
    Product.where("title LIKE ?", "%#{value}%")
  end

  def genre(value)
    @tag = Tag.find(params[:genre_id])
    @datas = @genre.products.all
  end

  def tag(value)
    @tag = Tag.find(params[:tag_id])
    @datas = @tag.products.all
  end

  def search_for(model, value)
    if model == "product"
      product(value)
    elsif model == "genre"
      genre(value)
    elsif model == "tag"
      tag(value)
    end
  end

end
