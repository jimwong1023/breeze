class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transactions_params)
    if transaction.save
      redirect_to cars_path
    else
      flash[:notice] = transaction.errors.full_messages
      redirect_to cars_path
    end
  end

  private
    def transactions_params
      params.require(:transaction).permit(:event_type, :ex_date, :car_id, :user_id)
    end
end