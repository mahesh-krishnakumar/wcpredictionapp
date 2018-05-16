class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :nick_name, :string
    add_column :users, :avatar, :string
    add_column :users, :type, :string
  end
end
