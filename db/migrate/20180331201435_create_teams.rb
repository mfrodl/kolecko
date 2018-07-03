class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :password
      t.string :phone
      t.boolean :payed

      t.string :player1_name
      t.string :player1_email
      t.string :player2_name
      t.string :player2_email
      t.string :player3_name
      t.string :player3_email
      t.string :player4_name
      t.string :player4_email

      t.timestamps
    end
  end
end
