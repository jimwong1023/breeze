class CarsController < ApplicationController
  def index
    scrub_transactions
    @cars = Car.all
  end

  def show
    scrub_transactions

    @car = Car.find_by_id(params[:id])
    @member = @car.reserved_or_occupied_by
    @transactions = @car.transactions.order(created_at: :desc)
  end
end