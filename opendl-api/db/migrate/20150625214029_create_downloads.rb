class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :url, null: false
      t.string :http_username
      t.string :http_password
      t.string :status, null: false, default: "initial"
      t.datetime :started_at
      t.datetime :finished_at
      t.text :error

      t.timestamps null: false
    end
  end
end
