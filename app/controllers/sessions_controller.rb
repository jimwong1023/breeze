class SessionsController < ApplicationController
  def create
    if params[:session]
      if user = User.find_by_id(params[:session][:id])
        login user
        return redirect_to user_path user
      end
    end
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end