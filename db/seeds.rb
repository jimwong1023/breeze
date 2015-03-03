# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
start_date = Date::strptime('2015-02-18', "%Y-%m-%d")

10.times do |i|
  User.create(created_at: (start_date + i))
end

9.times do
  Car.create(created_at: start_date)
end
#2015-02-18
Tracking.create(available_cars: 9, total_cars: 9, created_at: start_date)
#2015-02-19
Tracking.create(available_cars: 8, total_cars: 9, created_at: (start_date + 1))
#2015-02-20
Tracking.create(available_cars: 7, total_cars: 9, created_at: (start_date + 2))
#2015-02-21
Tracking.create(available_cars: 8, total_cars: 9, created_at: (start_date + 3))
#2015-02-22
Tracking.create(available_cars: 7, total_cars: 9, created_at: (start_date + 4))
#2015-02-23
Tracking.create(available_cars: 8, total_cars: 9, created_at: (start_date + 5))
7.times do |i|
  Tracking.create(available_cars: 8, total_cars: 9, created_at: (start_date + (i+6)))
end

t = Transaction.new(user_id: 1, car_id: 1, reserve_date: (start_date + 1), occupy_date: (start_date + 1), return_date: (start_date + 2), vacate_date: (start_date + 2))
t.save(validate: false)
t = Transaction.new(user_id: 2, car_id: 2, reserve_date: (start_date + 2), occupy_date: (start_date + 2), return_date: (start_date + 4), vacate_date: (start_date + 4))
t.save(validate: false)
t = Transaction.new(user_id: 3, car_id: 3, reserve_date: (start_date + 4), occupy_date: (start_date + 4), return_date: Date::strptime('2015-03-02', "%Y-%m-%d"), vacate_date: Date::strptime('2015-03-02', "%Y-%m-%d"))
t.save(validate: false)