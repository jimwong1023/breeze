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

    #change to case
    if instance.event_type == 'vacate'
      instance.user_id = car.user_id
    elsif instance.event_type == 'return'
      instance.user_id = car.user_id
    end
  }

  after_create {|instance|
    car = instance.car
    if instance.event_type == 'occupy'
      instance.close_date = Time.now
      instance.save!
      car.user = instance.user
      car.save!
    elsif instance.event_type == 'vacate'
      instance.close_date = Time.now
      instance.save!
      car.user = nil
      car.save!
    end
  }
end