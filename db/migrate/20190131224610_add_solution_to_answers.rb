class AddSolutionToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :solution, foreign_key: true
  end
end
