class SheltersController < ApplicationController
  def index
    @shelters = Shelter.all

    if params[:search].present?
      @shelters = @shelters.where("name ILIKE ?", "%#{params[:search]}%")
    end

    if params[:category].present?
      @shelters = @shelters.where(category_id: params[:category])
    end

    @shelters = @shelters.page(params[:page]).per(10)
  end

  def show
    @shelter = Shelter.find(params[:id])
    @pets = @shelter.pets
  end
end
