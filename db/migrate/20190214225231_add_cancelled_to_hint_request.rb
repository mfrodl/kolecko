class AddCancelledToHintRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :hint_requests, :cancelled, :boolean
  end
end
