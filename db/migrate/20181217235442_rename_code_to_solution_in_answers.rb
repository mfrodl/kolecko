class RenameCodeToSolutionInAnswers < ActiveRecord::Migration[5.1]
  def change
    rename_column :answers, :code, :solution
  end
end
