class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.references :puzzle, foreign_key: true
      t.string :text
      t.integer :points

      t.timestamps
    end
  end
end
