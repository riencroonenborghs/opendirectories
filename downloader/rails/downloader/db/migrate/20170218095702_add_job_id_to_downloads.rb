class AddJobIdToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :job_id, :text
  end
end
