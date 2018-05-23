class AddGoalsToPrediction < ActiveRecord::Migration[5.2]
  def change
    add_column :predictions, :team_1_goals, :integer
    add_column :predictions, :team_2_goals, :integer
  end
end
