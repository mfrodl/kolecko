class RemoveDepositFromTeam < ActiveRecord::Migration[5.1]
  def change
    remove_column :teams, :deposit, :integer
  end
end
