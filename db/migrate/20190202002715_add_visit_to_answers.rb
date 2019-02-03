class AddVisitToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :visit, foreign_key: true
  end
end
