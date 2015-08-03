class Download < ActiveRecord::Base
  INITIAL = "initial"
  QUEUED  = "queued"
  BUSY    = "busy"
  DONE    = "done"
  ERROR   = "error"

  belongs_to :user
  
  validates :url, presence: true
  validates :status, inclusion: { in: [INITIAL, QUEUED, BUSY, DONE, ERROR] }
  validate :http_credentials

  scope :last_n, lambda { |n| order(id: :desc).limit(n) }
  scope :last_10, -> { order(id: :desc).limit(10) }
  scope :queued, -> { where(status: QUEUED) }
  scope :busy, -> { where(status: BUSY) }
  scope :done, -> { where(status: DONE) }
  scope :error, -> { where(status: ERROR) }


  def self.latest
    [queued.last_n(5), busy.last_n(5), done.last_n(5), error.last_n(5)].compact.flatten
  end

  def run!
    begin
      update_attributes!(started_at: Time.zone.now, status: BUSY)
      system build_cmd
      update_attributes!(finished_at: Time.zone.now, status: DONE)
    rescue => e
      update_attributes!(finished_at: Time.zone.now, status: ERROR, error: e.message)
    end
  end

  def queue!
    DownloadWorker.perform_async(id)
    update_attributes!(status: QUEUED)
  end

  IGNORE_ATTRIBUTES = %w{created_at updated_at http_username http_password}
  def to_json
    attributes_copy = attributes
    IGNORE_ATTRIBUTES.each { |attribute| attributes_copy.delete(attribute) }
    attributes_copy
  end

private

  def cmd
    File.join(Rails.root, "bin", "opendir_dl.rb")
  end

  def build_cmd
    array = ["#{cmd} --output #{ENV["DOWNLOAD_DIRECTORY"]} --no-check-cert"]
    array << " --user #{self.http_username} --password #{self.http_password} " if http_credentials?
    array << " \"#{self.url}\" "
    array.join(" ")
  end

  def http_credentials
    errors.add(:http_username, "no HTTP password set") if http_username.present? && !http_password.present?
    errors.add(:http_password, "no HTTP username set") if http_password.present? && !http_username.present?
  end

  def http_credentials?
    self.http_username.present? && self.http_password.present?
  end
end
