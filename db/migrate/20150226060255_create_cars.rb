class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.belongs_to :user
      t.integer :current_transaction_id

      t.timestamps
    end
  end
end
