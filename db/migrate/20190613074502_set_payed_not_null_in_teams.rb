class SetPayedNotNullInTeams < ActiveRecord::Migration[5.1]
  def change
    change_column_null :teams, :payed, false, false
    change_column_default :teams, :payed, false
  end
end
