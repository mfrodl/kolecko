class RemoveSolutionFromPuzzles < ActiveRecord::Migration[5.1]
  def change
    remove_column :puzzles, :solution, :string
  end
end
