class AddLockedToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :locked, :boolean, default: true
  end
end
