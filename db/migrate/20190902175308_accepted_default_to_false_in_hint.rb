class AcceptedDefaultToFalseInHint < ActiveRecord::Migration[5.1]
  def change
    change_column :hints, :accepted, :boolean, default: false
  end
end
