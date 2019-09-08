class AddTeamIdToUnlockedMains < ActiveRecord::Migration[5.1]
  def change
    add_column :unlocked_mains, :team_id, :bigint
  end
end
