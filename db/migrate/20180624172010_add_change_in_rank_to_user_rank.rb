class AddChangeInRankToUserRank < ActiveRecord::Migration[5.2]
  def change
    add_column :user_ranks, :change_in_rank, :integer
  end
end
