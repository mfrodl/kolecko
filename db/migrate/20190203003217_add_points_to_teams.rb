class AddPointsToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :points, :integer, default: 0
  end
end
