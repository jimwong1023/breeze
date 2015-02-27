# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  User.create
end

8.times do
  Car.create
end

u = User.find(1)
c = Car.find(1)

Transaction.create(user_id: u.id, car_id: c.id, ex_date: (Time.now + 10000), event_type: 'reserve')
Transaction.create(user_id: u.id, car_id: c.id, ex_date: Time.now, event_type: 'occupy', close_date: Time.now )