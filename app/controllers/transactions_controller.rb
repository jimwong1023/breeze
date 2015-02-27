class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transactions_params)
    if transaction.save
      redirect_to user_path current_user
    else
      flash[:notice] = transaction.errors.full_messages
      redirect_to user_path current_user
    end
  end

  private
    def transactions_params
      params.require(:transaction).permit(:event_type, :ex_date, :car_id, :user_id)
    end
end