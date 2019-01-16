class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.references :team, foreign_key: true
      t.references :puzzle, foreign_key: true
      t.integer :wrong_answers, default: 0
      t.timestamp :solved_at

      t.timestamps
    end
  end
end
