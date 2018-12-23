class AddSolutionToPuzzle < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :solution, :string
  end
end
