class PetsController < ApplicationController
  def show
    @pet = Pet.find(params[:id])
    @shelter = @pet.shelter
    @tags = @pet.tags
  end
end
