class RemoveUniqueKeyOnDownloads < ActiveRecord::Migration
  def change
    remove_index :downloads, [:user_id, :url]
  end
end
