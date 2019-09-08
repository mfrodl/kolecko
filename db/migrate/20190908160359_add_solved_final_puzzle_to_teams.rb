class AddSolvedFinalPuzzleToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :solved_final_puzzle, :boolean, default: false, null: false
  end
end
