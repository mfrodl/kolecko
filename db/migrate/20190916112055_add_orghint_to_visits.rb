class AddOrghintToVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :visits, :orghint, :boolean, null: false, default: false
  end
end
