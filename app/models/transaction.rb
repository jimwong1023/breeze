class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :car

  validates_presence_of :car, :user
  validate :one_open_transaction, :future_reserve_date

  # CREATE SERVICE LAYER TO REMOVE BUSINESS LOGIC FROM MODELS 
  # (business logic included here to save time)

  def one_open_transaction
    user = User.find_by_id(user_id)
    car = Car.find_by_id(car_id)

    if !id && (user.current_transaction || car.current_transaction)
      errors.add(:transaction, "cannot have multiple on same entities")
    end
  end

  def future_reserve_date
    if !id && (reserve_date.to_date < Time.now.utc.to_date)
      errors.add(:transaction, "cannot have reserve date after today.")
    end
  end
end