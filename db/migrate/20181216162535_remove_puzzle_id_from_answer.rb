class RemovePuzzleIdFromAnswer < ActiveRecord::Migration[5.1]
  def change
    remove_reference :answers, :puzzle, foreign_key: true
  end
end
