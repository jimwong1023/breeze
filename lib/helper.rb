module Helper
  def cars_available?
    if Car.where(user_id: nil).length > 0
      return true
    end
    return false
  end

  def available_cars
    results = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT c.id
        FROM cars AS c
    SQL

    results.map {|hash| hash["id"]} - unavailable_cars
  end

  def unavailable_cars
    results = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT c.id
        FROM cars AS c, transactions as t
        WHERE t.car_id = c.id
        AND t.close_date IS NULL
        OR c.user_id IS NOT NULL
    SQL

    results.map {|hash| hash["id"]}
  end

  #Should be a task that runs every hour/day to clean missed reservations
  def scrub_transactions
    #8 Hour grace period to pick up / return car before killing reservation / return
    transactions = Transaction.where("ex_date < ? AND close_date is NULL", (Time.now + 8.hours))
    transactions.each do |t|
      t.close_date = Time.now
      t.save
    end
  end
end