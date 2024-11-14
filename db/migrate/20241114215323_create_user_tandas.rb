class CreateUserTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tandas do |t|
      t.integer :goal_id
      t.integer :user_id

      t.timestamps
    end
  end
end
