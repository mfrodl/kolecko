class CreatePuzzles < ActiveRecord::Migration[5.1]
  def change
    create_table :puzzles do |t|
      t.integer :number
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
