class Car < ActiveRecord::Base
  has_many :transactions
  has_one :current_transaction, :class_name => "Transaction", :foreign_key => :current_car

  belongs_to :user

  def status
    if t = current_transaction
      if ((t.reserve_date + 1.day) > Time.now.utc) && t.occupy_date.nil?
        return "Reserved"
      elsif t.return_date && ((t.return_date + 1.day) > Time.now.utc) && t.vacate_date.nil?
        return "Returning"
      elsif t.occupy_date && (t.return_date.nil? || (t.return_date && (t.return_date + 1.day) < Time.now.utc))
        return "Occupied"
      end
    else
      return 'Available'
    end
  end

  def returning?
    t = current_transaction
    if t && t.return_date && ((t.return_date + 1.day) > Time.now.utc) && t.vacate_date.nil?
      return true
    end
    return false
  end

  def reserved?
    t = current_transaction
    if t && t.occupy_date.nil? && ((t.reserve_date + 1.day) > Time.now.utc)
      return true
    end
    return false
  end

  def occupied?
    t = current_transaction

    if t && t.occupy_date && ((t.occupy_date) < Time.now.utc) && (t.return_date.nil? || (t.return_date && (t.return_date + 1.day) < Time.now)) && t.vacate_date.nil?
      return true
    end
    return false
  end
end