class CreatePredictions < ActiveRecord::Migration[5.2]
  def change
    create_table :predictions do |t|
      t.integer :match_id, index: true
      t.integer :user_id, index: true
      t.string :decider
      t.integer :winner_id
      t.timestamps
    end
  end
end
