class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :car

  validates_presence_of :car
  validate :no_same_open_transaction, :user_cannot_occupy_multiple_cars

  # CREATE SERVICE LAYER TO REMOVE BUSINESS LOGIC FROM MODELS 
  # (business logic included here to save time)

  # Close out all pending transactions due to new action
  before_create {|instance|
    results = instance.car.transactions.where("close_date is NULL")
    results.each do |t|
      t.close_date = Time.now
      t.save
    end

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

  #Should compact into one validation for less DB reads
  #seperated out for readability
  def no_same_open_transaction
    if event_type == "reserve" || event_type == "return"
      car = Car.find_by_id(car_id)
      user = User.find_by_id(user_id) || car.user
      if car.transactions.where("event_type = ? AND close_date is NULL", event_type).length > 0 || user.transactions.where("event_type = ? AND close_date is NULL", event_type).length > 0
        errors.add(:event_type, "similar transaction found")
      elsif event_type == "reserve" && user.car
        errors.add(:user, "must vacate current car")
      end
    end
  end

  def user_cannot_occupy_multiple_cars
    if event_type == "occupy"
      user = User.find_by_id(user_id)
      if user.car
        errors.add(:user, "cannot occupy multiple vehicles")
      end
    end
  end
end