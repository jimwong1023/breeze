class UsersController < ApplicationController
  def create
    user = User.create
    redirect_to users_path
  end

  def show
    @user = User.find_by_id(params[:id])
    @transactions = @user.transactions.order(created_at: :desc)
  end

  def index
    @users = User.all
  end
end