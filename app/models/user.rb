class User < ActiveRecord::Base
  has_many :transactions
  has_one :car
end