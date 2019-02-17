class AddOpenedToHint < ActiveRecord::Migration[5.1]
  def change
    add_column :hints, :opened, :boolean
  end
end
