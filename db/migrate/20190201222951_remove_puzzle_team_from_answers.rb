class RemovePuzzleTeamFromAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :answers, :puzzle, foreign_key: true
    remove_reference :answers, :team, foreign_key: true
  end
end
