class RemoveNumberFromPuzzles < ActiveRecord::Migration[5.1]
  def change
    remove_column :puzzles, :number, :int
  end
end
