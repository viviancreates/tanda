class CreateTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :tandas do |t|
      t.integer :goal_amount
      t.integer :creator_id
      t.string :name
      t.datetime :due_date

      t.timestamps
    end
  end
end
