class UsersController < ApplicationController
  def create
    user = User.create
    redirect_to users_path
  end

  def show
    scrub_transactions
    @user = User.find_by_id(params[:id])
    if available_cars.first
      @available_car = Car.find_by_id(available_cars.first)
    end
  end

  def index
    @users = User.all
  end
end