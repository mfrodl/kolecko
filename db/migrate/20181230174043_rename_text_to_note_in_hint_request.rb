class RenameTextToNoteInHintRequest < ActiveRecord::Migration[5.1]
  def change
    rename_column :hint_requests, :text, :note
  end
end
