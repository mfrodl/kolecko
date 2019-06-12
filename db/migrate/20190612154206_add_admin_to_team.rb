class AddAdminToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :admin, :boolean, null: false, default: false
  end
end
