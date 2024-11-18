class RenameGoalIdToTandaIdInUserTandas < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_tandas, :goal_id, :tanda_id
  end
end
