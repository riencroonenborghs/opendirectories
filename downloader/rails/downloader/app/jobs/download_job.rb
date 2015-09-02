class DownloadJob
  @queue = :downloader

  def self.perform(id)
    download = Download.find_by_id(id)
    raise StandardError.new "Cannot find download with ID #{id}" unless download
    download.run!
  end
end