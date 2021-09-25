class Admin::GenresController < ApplicationController

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to admin_genres_path, notice: "ジャンルを登録しました"
    else
      @genres = Genre.all
      @genre = Genre.new
      flash.now[:alert] = "ジャンルの登録に失敗しました"
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: "変更を保存しました"
    else
      flash.now[:alert] = "変更の保存に失敗しました"
      render :edit
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    if @genre.destroy
      @genre.image.purge
      redirect_to admin_genres_path, notice: "ジャンルを削除しました"
    else
      flash.now[:alert] = "削除に失敗しました"
      render :edit
    end
  end



  private

  def genre_params
    params.require(:genre).permit(:name, :image)
  end

end
