class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :current_transaction_id

      t.timestamps
    end
  end
end
