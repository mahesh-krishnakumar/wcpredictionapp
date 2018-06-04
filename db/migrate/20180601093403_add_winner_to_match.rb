class AddWinnerToMatch < ActiveRecord::Migration[5.2]
  def change
    add_reference :matches, :winner
  end
end
