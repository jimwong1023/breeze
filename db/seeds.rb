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

8.times do |i|
  Car.create(created_at: (Time.now - (i + 3).days))
end

6.times do |i|
  t = Transaction.new(user_id: (i + 1), car_id: (i + 1), reserve_date: (Time.now - i.days), occupy_date: (Time.now - i.days), return_date: (Time.now + i.days), vacate_date: (Time.now + i.days))
  t.save(validate: false)
end