class DownloadWorker
  include Sidekiq::Worker

  def perform(id)
    download = Download.find_by_id(id)
    raise StandardError.new "cannot find download with id #{id}" unless download
    download.run!
  end
end