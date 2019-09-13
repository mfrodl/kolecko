class AddOpenedToPuzzles < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :opened, :boolean, null: false, default: false
  end
end
