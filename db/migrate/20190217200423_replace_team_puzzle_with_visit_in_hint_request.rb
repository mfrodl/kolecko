class ReplaceTeamPuzzleWithVisitInHintRequest < ActiveRecord::Migration[5.1]
  def change
    remove_reference :hint_requests, :team, foreign_key: true
    remove_reference :hint_requests, :puzzle, foreign_key: true
    add_reference :hint_requests, :visit, foreign_key: true
  end
end
