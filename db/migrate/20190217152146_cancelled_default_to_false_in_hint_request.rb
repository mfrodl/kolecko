class CancelledDefaultToFalseInHintRequest < ActiveRecord::Migration[5.1]
  def change
    change_column :hint_requests, :cancelled, :boolean,
                  default: false, null: false
  end
end
