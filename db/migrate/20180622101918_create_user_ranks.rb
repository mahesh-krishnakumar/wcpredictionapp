class CreateUserRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ranks do |t|
      t.references :user
      t.references :group
      t.integer :rank
      t.float :points

      t.timestamps
    end
  end
end
