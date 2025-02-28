class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(id: params[:id])
    @pets = @tag.present? ? @tag.pets : []
  end
end
