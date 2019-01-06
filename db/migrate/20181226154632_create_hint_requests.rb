class CreateHintRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :hint_requests do |t|
      t.references :team, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
