class HomepageController < ApplicationController
  def home
    log_tracking
    available_query
    utilization_query
  end

  private
    def available_query
      if params[:available]
        if tracking = cars_available_on(params[:available][:search_date])
          @available = tracking.available_cars
        else
          @available = 0
        end
      end
    end

    def utilization_query
      if params[:utilization]
        results = cars_available_between(params[:utilization][:search_date_start], params[:utilization][:search_date_end])
        if results.first["available"]
          @utilization = ((results.first["total"].to_i - results.first["available"].to_i).to_f / results.first["total"].to_f)
        else
          @utilization = 0
        end
      end
    end
end