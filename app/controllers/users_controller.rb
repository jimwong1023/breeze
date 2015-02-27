class UsersController < ApplicationController
  def create
    user = User.new
    if user.save
      login user
      redirect_to user_path user
    else
      redirect_to root_path
    end
  end

  def show
    scrub_transactions
    if available_cars.first
      @available_car = Car.find_by_id(available_cars.first)
    end
  end
end