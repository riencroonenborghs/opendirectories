class DownloadJob
  include Resque::Plugins::Status

  @queue = :downloader

  def perform
    download = Download.find_by_id options["id"]
    raise StandardError.new "Cannot find download with ID #{options["id"]}" unless download
    download.run!
  end
end