class AddTeamRefToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :team, foreign_key: true
  end
end
