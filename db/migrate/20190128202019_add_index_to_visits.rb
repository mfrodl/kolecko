class AddIndexToVisits < ActiveRecord::Migration[5.1]
  def change
    add_index :visits, [:team_id, :puzzle_id], unique: true
  end
end
