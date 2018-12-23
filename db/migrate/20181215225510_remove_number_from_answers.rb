class RemoveNumberFromAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :answers, :number, :integer
  end
end
