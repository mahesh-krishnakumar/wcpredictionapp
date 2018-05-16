class UpdateTeamColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :teams, :name, :full_name
    rename_column :teams, :flag, :short_name
  end
end
