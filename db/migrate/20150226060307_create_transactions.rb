class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :car
      t.belongs_to :user
      t.date :reserve_date
      t.date :occupy_date
      t.date :return_date
      t.date :vacate_date
      t.integer :current_user
      t.integer :current_car

      t.timestamps
    end
  end
end
