class AddSolvedMainPuzzlesToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :solved_main_puzzles, :int, default: 0, null: 0
  end
end
