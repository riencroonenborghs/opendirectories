class AddSubsThindToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :download_subs, :boolean, default: false, null: false
    add_column :downloads, :srt_subs, :boolean, default: false, null: false
  end
end
