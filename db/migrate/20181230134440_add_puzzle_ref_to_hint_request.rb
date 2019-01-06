class AddPuzzleRefToHintRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :hint_requests, :puzzle, foreign_key: true
  end
end
