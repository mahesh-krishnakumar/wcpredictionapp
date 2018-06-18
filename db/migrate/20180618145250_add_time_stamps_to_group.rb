class AddTimeStampsToGroup < ActiveRecord::Migration[5.2]
  def change
    time = DateTime.new(2018, 06, 13)
    add_timestamps(:groups, default: time, null: false)
  end
end
