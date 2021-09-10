class Public::HomesController < ApplicationController

  def top
    @genres = Genre.all
    @tags = Tag.all
  end

  def about
  end

end
