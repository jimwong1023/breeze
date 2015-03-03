class CreateTracking < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.integer :available_cars
      t.integer :total_cars
      t.date :created_at
    end
  end
end
