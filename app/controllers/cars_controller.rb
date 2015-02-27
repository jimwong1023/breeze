class CarsController < ApplicationController
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find_by_id(params[:id])
    @member = @car.reserved_or_occupied_by
  end
end