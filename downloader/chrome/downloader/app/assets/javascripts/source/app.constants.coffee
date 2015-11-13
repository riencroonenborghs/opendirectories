app = angular.module "downloader.constants", []

app.constant "ICONS",
  # initial: "cloud_circle"
  queued: "cloud"
  started: "cloud_download"
  finished: "done"
  error: "error"
  cancelled: "cloud_off"
