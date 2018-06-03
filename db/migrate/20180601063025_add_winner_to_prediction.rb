class AddWinnerToPrediction < ActiveRecord::Migration[5.2]
  def change
    add_reference :predictions, :winner
  end
end
