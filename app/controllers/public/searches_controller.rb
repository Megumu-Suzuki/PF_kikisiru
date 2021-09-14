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
    @genre = Genre.find(params[:genre_id])
    @datas = @genre.products.all
  end

  def tag(value)
    @tag = Tag.find(params[:tag_id])
    @products = @tag.products.all
    @reviews = Product.joins({:reviews => :tags }).where(reviews:{tags: {id: @tag.id}}) #Product > reviews > tagsのidで検索
    @product_tag = @products | @reviews #@products(Productのcollection) + @reviews(Productsのcollection)を足す
    @datas = @product_tag.uniq #@product_tagのuniqさを担保 Collection.uniq
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
