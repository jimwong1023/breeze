class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transactions_params)

    if params[:transaction][:car_id]
      car = Car.find_by_id(params[:transaction][:car_id])
    else
      car = Car.find_by_id(available_cars.first)
      if car.nil?
        #Buy car if none available
        car = Car.create
      end
    end

    transaction.car = car
    if transaction.save
      # CREATE SERVICE LAYER TO REMOVE BUSINESS LOGIC FROM MODELS/CONTROLLERS 
      # (business logic included here to save time)
      car = transaction.car
      user = transaction.user

      car.current_transaction = transaction
      car.current_transaction_id = transaction.id
      car.user = user
      car.save

      user.current_transaction = transaction
      user.current_transaction_id = transaction.id
      user.car = car
      user.save
      redirect_to users_path
    else
      flash[:notice] = transaction.errors.full_messages
      redirect_to users_path
    end
  end

  def update
    transaction = Transaction.find_by_id(params[:transaction][:id])
    action = params[:transaction][:action]
    if action == "occupy"
      transaction.occupy_date = Time.now.utc.to_date
    elsif action == "return"
      transaction.return_date = params[:transaction][:return_date]
    elsif action == "vacate"
      transaction.vacate_date = Time.now.utc.to_date
      transaction.current_user = nil
      transaction.current_car = nil
      if !transaction.return_date
        transaction.return_date = Time.now.utc.to_date
      end
    end
    #refactor into service layer
    if transaction.save
      if action == "vacate"
        car = transaction.car
        car.user = nil
        car.current_transaction_id = nil
        car.save

        user = transaction.user
        user.car = nil
        user.current_transaction_id = nil
        user.save
      end
      redirect_to users_path
    else
      flash[:notice] = transaction.errors.full_messages
      redirect_to users_path
    end
  end

  private
    def transactions_params
      params.require(:transaction).permit(:reserve_date, :occupy_date, :user_id, :car_id)
    end
end