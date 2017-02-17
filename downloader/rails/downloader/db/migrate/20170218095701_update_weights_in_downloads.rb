class UpdateWeightsInDownloads < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.downloads.each_with_index do |download, index|
        download.update_attributes!(weight: index)
      end
    end
  end
end
