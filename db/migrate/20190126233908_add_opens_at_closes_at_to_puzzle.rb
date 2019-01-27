class AddOpensAtClosesAtToPuzzle < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :opens_at, :datetime
    add_column :puzzles, :closes_at, :datetime
  end
end
