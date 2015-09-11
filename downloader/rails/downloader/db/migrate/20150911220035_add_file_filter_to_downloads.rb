class AddFileFilterToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :file_filter, :string
  end
end
