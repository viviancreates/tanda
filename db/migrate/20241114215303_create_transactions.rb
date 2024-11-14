class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :user_tanda_id
      t.integer :amount
      t.datetime :date
      t.string :description
      t.string :transaction_type

      t.timestamps
    end
  end
end
