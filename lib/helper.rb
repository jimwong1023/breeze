module Helper
  def available_cars
    results = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT c.id
      FROM cars as c
      WHERE c.current_transaction_id IS NULL
    SQL
    results.map {|hash| hash["id"]}
  end
end