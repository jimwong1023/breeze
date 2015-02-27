class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :car
      t.belongs_to :user
      t.string :event_type
      t.datetime :ex_date
      t.datetime :close_date

      t.timestamps
    end
  end
end
