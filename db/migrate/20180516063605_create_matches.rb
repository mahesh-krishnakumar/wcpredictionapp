class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :team_1_id
      t.integer :team_2_id
      t.string :venue
      t.datetime :kick_off
      t.integer :team_1_goals
      t.integer :team_2_goals
      t.boolean :knock_out
      t.string :decider

      t.timestamps
    end
  end
end
