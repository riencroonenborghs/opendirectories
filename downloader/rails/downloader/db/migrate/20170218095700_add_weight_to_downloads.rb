class AddWeightToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :weight, :int, default: 9999, null: false
  end
end
