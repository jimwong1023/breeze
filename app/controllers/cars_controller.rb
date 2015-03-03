class CarsController < ApplicationController
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find_by_id(params[:id])
    @transactions = @car.transactions.order(created_at: :desc)
  end

  def create
    Car.create
    redirect_to cars_path
  end
end