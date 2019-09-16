class AddDeadToVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :dead, :boolean, null: false, default: false
  end
end
