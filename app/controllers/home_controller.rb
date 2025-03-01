class HomeController < ApplicationController
  def index
    @pets = Pet.page(params[:page]).per(9)
  end
end
