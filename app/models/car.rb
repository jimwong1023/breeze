class Car < ActiveRecord::Base
  has_many :transactions
  belongs_to :user

  #Create transaction showing existance of new car
  after_create { |instance|
    Transaction.create(
      car: instance, 
      event_type: 'new', 
      ex_date: Time.now,
      close_date: Time.now)
  }

  def status
    if self.user
      return 'occupied'
    elsif self.reserved?
      return 'reserved'
    else
      return 'available'
    end
  end

  def current_transaction
    self.transactions.where("close_date is NULL").first
  end

  def returning?
    if self.transactions.where("event_type= ? AND close_date is NULL", 'return').length > 0
      return true
    end
    return false
  end

  def reserved?
    if self.transactions.where("event_type = ? AND close_date is NULL AND ex_date > NOW()", 'reserve').length > 0
      return true
    end
    return false
  end

  def reserved_or_occupied_by
    if self.user
      return self.user
    elsif r = self.transactions.where("event_type = ? AND close_date is NULL", 'reserve').first
      return r.user
    end
    return false
  end
end