class BountyDefaultToZeroInHintRequests < ActiveRecord::Migration[5.1]
  def change
    change_column_default :hint_requests, :bounty, 0
  end
end
