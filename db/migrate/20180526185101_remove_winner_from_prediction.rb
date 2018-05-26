class RemoveWinnerFromPrediction < ActiveRecord::Migration[5.2]
  def change
    remove_column :predictions, :winner_id, :integer
  end
end
