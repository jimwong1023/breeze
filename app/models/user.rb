class User < ActiveRecord::Base
  has_many :transactions
  has_one :current_transaction, :class_name => "Transaction", :foreign_key => :current_user

  has_one :car

  #shares same methods as car.rb perhaps break into module to refactor
  def has_reservation?
    t = current_transaction

    if t && t.occupy_date.nil? && ((t.reserve_date + 1.day) > Time.now.utc)
      return true
    end
    return false
  end

  def has_return?
    t = current_transaction
    if t && t.return_date && ((t.return_date + 1.day) > Time.now.utc) && t.vacate_date.nil?
      return true
    end
    return false
  end

  def occupying?
    t = current_transaction

    if t && t.occupy_date && ((t.occupy_date) < Time.now.utc) && (t.return_date.nil? || (t.return_date && (t.return_date + 1.day) < Time.now.utc)) && t.vacate_date.nil?
      return true
    end
    return false
  end

  def status
    if t = current_transaction
      if ((t.reserve_date + 1.day) > Time.now.utc) && t.occupy_date.nil?
        return "Reserving"
      elsif t.return_date && ((t.return_date + 1.day) > Time.now.utc) && t.vacate_date.nil?
        return "Returning"
      elsif t.occupy_date && (t.return_date.nil? || (t.return_date && (t.return_date + 1.day) < Time.now.utc))
        return "Occupying"
      end
    else
      return "No Car"
    end
  end
end