class User < ActiveRecord::Base
  has_many :transactions
  has_one :car

  #shares same methods as car.rb perhaps break into module to refactor
  def has_reservation?
    if self.transactions.where("event_type = ? AND close_date is NULL AND ex_date > NOW()", 'reserve').length > 0
      return true
    end
    return false
  end

  def has_return?
    if self.transactions.where("event_type = ? AND close_date is NULL", 'return').length > 0
      return true
    end
    return false
  end

  def current_transaction
    self.transactions.where("close_date is NULL").first
  end
end