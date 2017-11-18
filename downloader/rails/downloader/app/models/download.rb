class Download < ActiveRecord::Base
  STATUS_INITIAL    = "initial"
  STATUS_QUEUED     = "queued"
  STATUS_STARTED    = "started"
  STATUS_FINISHED   = "finished"
  STATUS_ERROR      = "error"
  STATUS_CANCELLED  = "cancelled"
  VALID_STATUSES    = [STATUS_INITIAL, STATUS_QUEUED, STATUS_STARTED, STATUS_FINISHED, STATUS_ERROR, STATUS_CANCELLED]

  belongs_to :user

  validates_presence_of :url
  validates_format_of :url, with: URI::regexp(%w(http https ftp))
  validates_inclusion_of :status, in: VALID_STATUSES
  validates_inclusion_of :audio_format, in: ["best", "aac", "flac", "mp3", "m4a", "opus", "vorbis", "wav"]
  validate :http_credentials

  scope :last_n,    lambda { |n| order(id: :desc).limit(n) }
  scope :last_10,   -> { order(id: :desc).limit(10) }
  scope :initial,   -> { where(status: STATUS_INITIAL) }
  scope :queued,    -> { where(status: STATUS_QUEUED) }
  scope :started,   -> { where(status: STATUS_STARTED) }
  scope :finished,  -> { where(status: STATUS_FINISHED) }
  scope :error,     -> { where(status: STATUS_ERROR) }
  scope :cancelled, -> { where(status: STATUS_CANCELLED) }
  scope :for_clearing, -> { where(status: [STATUS_FINISHED, STATUS_ERROR, STATUS_CANCELLED] ) }

  def self.latest
    [initial.last_n(5), queued.last_n(5), started.last_n(5), finished.last_n(5), error.last_n(5)].compact.flatten
  end

  def run!    
    prep_output_path!

    begin
      return if cancelled?
      start!
      if Rails.env.development?
        puts "-------------------------------"
        puts "download_type: #{download_type}"
        puts download_command
        puts "-------------------------------"
        sleep(rand(10))
      else
        system(download_command) if download_command
      end
      finish!
    rescue => e
      error!(e.message)
    end    
  end

  def destroy
    remove_from_resque!
    update(weight: 9999)
    super
  end

  def enqueue!    
    return if queued? || started?
    job_id = DownloadJob.create id: self.id
    update(job_id: job_id, weight: user.downloads.queued.count)
    queue!
  end
  
  def front_enqueue!
    return if queued? || started?

    # remove all from resque
    user.downloads.queued.map(&:remove_from_resque!)

    # update weights: self is 0, rest is index + 1
    update_attributes!(weight: 0)
    user.downloads.queued.each_with_index do |download, index|
      if download.id != self.id
        download.update_attributes!(weight: index + 1)
      end
    end

    # enqueue myself, then the other ones
    job_id = DownloadJob.create id: self.id
    update(job_id: job_id)
    queue!
    user.downloads.queued do |download, index|
      if download.id != self.id
        job_id = DownloadJob.create id: self.id
        update(job_id: job_id)
        queue!
      end
    end
  end

  def queue!
    update(status: STATUS_QUEUED, queued_at: Time.zone.now, started_at: nil, finished_at: nil, error: nil)
  end

  def queued?
    status == STATUS_QUEUED
  end


  def start!    
    update(status: STATUS_STARTED, started_at: Time.zone.now, finished_at: nil, error: nil)
  end

  def started?
    status == STATUS_STARTED
  end


  def finish!
    update(status: STATUS_FINISHED, finished_at: Time.zone.now)
  end

  def error!(message)
    update(status: STATUS_ERROR, finished_at: Time.zone.now, error: message)
  end


  def cancel!
    remove_from_resque!
    update(status: STATUS_CANCELLED, cancelled_at: Time.zone.now, weight: 9999)
    user.downloads.queued.each_with_index do |download, index|
      download.update_attributes!(weight: index)
    end
  end

  def cancelled?
    status == STATUS_CANCELLED
  end

  def remove_from_resque!
    Resque::Plugins::Status::Hash.kill(self.job_id)
  end

  def to_json
    hash = Hash.new.tap do |ret|
      attributes.map do |key, value|
        ret[key] = value
      end
    end
    hash["user"] = {id: user_id, email: user.email}
    hash
  end

private

  def http_credentials
    errors.add(:http_username, "no HTTP password set") if http_username.present? && !http_password.present?
    errors.add(:http_password, "no HTTP username set") if http_password.present? && !http_username.present?
  end

  def http_credentials?
    http_username.present? && http_password.present?    
  end

  def prep_output_path!
    dir = ENV['OUTPUT_PATH']
    FileUtils.mkdir_p(dir) unless File.exists?(dir)
  end

  def download_type
    @download_type ||= begin
      if url =~ /youtube\.com/
        :youtube 
      elsif url =~ /iplayer/
        :bbc_iplayer
      else 
        :opendir_dl
      end
    end
  end

  def download_command
    @download_command ||= begin
      case download_type
      when :youtube
        youtube_dl_command
      when :bbc_iplayer
        iplayer_command
      when :opendir_dl
        opendir_dl_command
      end
    end
  end

  def youtube_dl_command
    program = "youtube-dl"
    cmd = [program]
    cmd << "--extract-audio --audio-format \"#{audio_format}\" --audio-quality 0" if audio_only
    cmd << "--write-sub" if download_subs
    cmd << "--convert-subs srt" if srt_subs
    cmd << "--continue --output \"#{ENV["OUTPUT_PATH"]}/%(title)s-%(id)s.%(ext)s\""
    cmd << "\"#{url}\" "
    cmd.join(" ")
  end

  def opendir_dl_command
    program = File.join(Rails.root, "bin", "opendir_dl.rb")
    cmd = ["ruby #{program} --output \"#{ENV["OUTPUT_PATH"]}\" --no-check-cert"]
    cmd << "--user #{http_username} --password #{http_password}" if http_credentials?
    cmd << "--files \"#{file_filter}\"" if file_filter.present?
    cmd << "\"#{url}\" "
    cmd.join(" ")
  end

  def iplayer_command
    cmd = ["get_iplayer"]
    cmd << "--proxy #{ENV['PROXY']}" if ENV['PROXY']
    cmd << "--get \"#{url}\" --force --modes best"
    cmd << "--output \"#{ENV['OUTPUT_PATH']}\""
    cmd.join(" ")
  end
end
