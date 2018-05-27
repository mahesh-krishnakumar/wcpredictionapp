class ChangeKnockOutToStage < ActiveRecord::Migration[5.2]
  def up
    remove_column :matches, :knock_out
    add_column :matches, :stage, :string
  end

  def down
    add_column :matches, :knock_out, :string
    remove_column :matches, :stage
  end
end
