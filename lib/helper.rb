module Helper
  def available_cars
    results = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT c.id
      FROM cars as c
      WHERE c.current_transaction_id IS NULL
    SQL
    results.map {|hash| hash["id"]}
  end

  #This should be a daily cron task
  def log_tracking
    if Tracking.last.created_at.to_date != Time.now.utc.to_date
      track = Tracking.new(available_cars: available_cars.count, total_cars: Car.all.count, created_at: Time.now.utc.to_date)
      track.save!
    end
  end

  def cars_available_on(date)
    Tracking.where(created_at: date).first
  end

  def cars_available_between(start_date, end_date)
    results = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT sum(t.available_cars) AS available, sum(t.total_cars) AS total 
      FROM trackings AS t 
      WHERE t.created_at BETWEEN '#{start_date}' 
      AND '#{end_date}';
    SQL
    results
  end
end