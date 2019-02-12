class AddDepositToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :deposit, :integer, default: 0
  end
end
