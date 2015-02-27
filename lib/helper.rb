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
end