class HomepageController < ApplicationController
  def home
    available
  end

  private
    # def utilization
    #   if params[:utilization]
    #     @utilization = utilization_during(params[:utilization][:search_date])
    #   end
    # end

    # #too expensive
    # def utilization_during(date)
    #   results = last_trans(date)
      
    #   result_hash = {}

    #   results.each do |hash|
    #     id = hash["id"]
    #     if result_hash[id]
    #       if result_hash[id]["created_at"] < hash["created_at"]
    #         result_hash[id]["created_at"] = hash["created_at"]
    #         result_hash[id]["event_type"] = hash["event_type"]
    #       end
    #     else
    #       result_hash[id] = {"event_type" => hash["event_type"], "created_at" => hash["created_at"]}
    #     end
    #   end
    #   count = 0
    #   result_hash.each do |k,v|
    #     count += 1 if v["event_type"] == "occupy"
    #   end
    #   utilzation = count.to_f/result_hash.count.to_f * 100
    # end

    def available
      if params[:available]
        @available = available_on(params[:available][:search_date])
      end
    end

    def available_on(date)
      results = available_count(date)
      count = 0
      results.each do |hash|
        count += hash["count"].to_i if ((hash["event_type"] == "new") || (hash["event_type"] == "vacate") || (hash["event_type"] == "reserve"))
      end
      count
    end

    def last_trans(date)
      results = ActiveRecord::Base.connection.select_all <<-SQL
        SELECT t.id, t.car_id, t.event_type, t.created_at, t.close_date
        FROM transactions as t
        WHERE t.created_at = (SELECT MAX(created_at)
                                FROM transactions as t2
                                WHERE t.created_at < '#{date}'
                                AND t.car_id = t2.car_id)
      SQL

      results
    end

    def available_count(date)
      results = ActiveRecord::Base.connection.select_all <<-SQL
        SELECT t.event_type, count(event_type)
        FROM transactions as t
        WHERE t.created_at = (SELECT MAX(created_at)
                                FROM transactions as t2
                                WHERE t.created_at < '#{date}'
                                AND t.car_id = t2.car_id)
        GROUP BY t.event_type
      SQL

      results
    end
end

# SELECT t.id, t.car_id, t.event_type, t.created_at, t.close_date
# FROM transactions as t
# WHERE t.created_at = (SELECT MAX(created_at)
#                         FROM transactions as t2
#                         WHERE t.created_at < '#{date}'
#                         AND t.car_id = t2.car_id)

# SELECT cars.id, transactions.event_type, transactions.created_at FROM cars
# FULL OUTER JOIN transactions
# ON cars.id = transactions.car_id
# WHERE cars.created_at < '#{date}'
# AND transactions.close_date < '#{date}'
# AND (transactions.event_type ='occupy' OR transactions.event_type = 'vacate' OR transactions.event_type = 'new')