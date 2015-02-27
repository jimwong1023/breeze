class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :car

  validates_presence_of :car

  # Close out all pending transactions due to new action
  before_create {|instance|
    results = instance.car.transactions.where("close_date is NULL")
    results.each do |t|
      t.close_date = Time.now
      t.save
    end
  }

  after_create {|instance|
    car = instance.car
    if instance.event_type == 'occupy'
      car.user = instance.user
      car.save!
    elsif instance.event_type == 'vacate'
      car.user = nil
      car.save!
    end
  }
end