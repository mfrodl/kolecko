class CreateHints < ActiveRecord::Migration[5.1]
  def change
    create_table :hints do |t|
      t.references :team
      t.references :hint_request
      t.string :text
      t.boolean :accepted

      t.timestamps
    end
  end
end
