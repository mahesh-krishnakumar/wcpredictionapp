class RemoveGroupFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :group
  end
end
