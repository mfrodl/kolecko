class AddPlaceToPuzzles < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :place, :text, null: "", default: ""
  end
end
