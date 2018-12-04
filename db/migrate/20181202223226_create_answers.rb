class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.integer :number
      t.string :code

      t.timestamps
    end
  end
end
