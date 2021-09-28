class Public::SearchesController < ApplicationController
  def search
    @genres = Genre.all
    @tags = Tag.limit(20).order("id DESC")
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    @datas = search_for(@model, @value).sort { |a, b| b.id <=> a.id }
    @datas = Kaminari.paginate_array(@datas).page(params[:page]).per(10)
  end

  private

  def product(value)
    Product.where("title LIKE ?", "%#{value}%")
  end

  def genre(value)
    @genre = Genre.find(params[:genre_id])
    @datas = @genre.products.all.includes([:reviews])
  end

  def tag(value)
    @tag = Tag.find(params[:tag_id])
    @products = @tag.products.all
    # Product > reviews > tagsのidで検索
    @reviews = Product.joins({ :reviews => :tags }).where(reviews: { tags: { id: @tag.id } })
    # @products(Productのcollection) + @reviews(Productsのcollection)を足す
    @product_tag = @products | @reviews
    # @product_tagのuniqさを担保 Collection.uniq
    @datas = @product_tag.uniq
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
