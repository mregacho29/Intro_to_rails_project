class TagsController < ApplicationController
  def show
    @tags = Tag.find(params[:id])
    @pets = @tags.pets
  end
end
