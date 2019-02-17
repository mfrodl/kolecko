class AddClosedToHintRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :hint_requests, :closed, :boolean, null: false, default: false
  end
end
