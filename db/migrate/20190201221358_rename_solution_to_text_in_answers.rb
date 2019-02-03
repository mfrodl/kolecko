class RenameSolutionToTextInAnswers < ActiveRecord::Migration[5.1]
  def change
    rename_column :answers, :solution, :text
  end
end
