class AddBountyToHintRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :hint_requests, :bounty, :integer
  end
end
