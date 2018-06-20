class RemoveDefaultValueFromGroupTimeStamps < ActiveRecord::Migration[5.2]
  def change
    change_column_default :groups, :created_at, nil
    change_column_default :groups, :updated_at, nil
  end
end
