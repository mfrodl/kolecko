class AddRatingToHint < ActiveRecord::Migration[5.1]
  def change
    add_column :hints, :rating, :integer
  end
end
