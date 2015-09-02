class AddCancelledAtToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :cancelled_at, :datetime
  end
end
