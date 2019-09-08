class AddPuzzleIdToUnlockedMains < ActiveRecord::Migration[5.1]
  def change
    add_column :unlocked_mains, :puzzle_id, :bigint
  end
end
