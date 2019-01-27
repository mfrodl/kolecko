class AddCoordinatesToPuzzle < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :latitude, :float
    add_column :puzzles, :longitude, :float
  end
end
