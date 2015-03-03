class Tracking < ActiveRecord::Base
  validates_presence_of :available_cars, :total_cars
end