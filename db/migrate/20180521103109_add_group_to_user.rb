class AddGroupToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :group, iundex: true
  end
end
