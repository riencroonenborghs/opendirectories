app = angular.module "downloader.downloads.controllers", []

app.controller "NewDownloadController", ["$scope", "$rootScope", "$mdDialog", "$http", "Server",
($scope, $rootScope, $mdDialog, $http, Server) ->
  $scope.model = {url: "", http_username: "", http_password: "", file_filter: ""}
  $scope.forms = {}
  $scope.error = null
  $scope.save = () ->
    success = ->
      $rootScope.$broadcast "downloads.get"
      $mdDialog.hide()
    failure = (message) ->
      $scope.error = message
    Server.service.create($scope.model).then success, failure
  $scope.close = -> $mdDialog.hide()
]

app.controller "DownloadsController", [ "$scope", "$rootScope", "$mdDialog", "Server", "$mdToast",
($scope, $rootScope, $mdDialog, Server, $mdToast) ->

  $scope.statuses = ["initial", "queued", "started", "finished", "error", "cancelled"]
  $scope.tabStatuses = ["queued", "started", "finished", "error", "cancelled"]

  showToast = (message) ->
    $mdToast.show($mdToast.simple().textContent(message).hideDelay(3000))

  $scope.downloads = {}
  $rootScope.$on "downloads.get", () ->
    $scope.getDownloads()

  $scope.getDownloads = ->
    $scope.downloads = {}
    Server.service.get("/api/v1/downloads.json").then (data) ->
      for download in data
        for status in $scope.statuses
          $scope.downloads[status] ||= []
          $scope.downloads[status].push download if download.status == status
      console.debug $scope.downloads
  
  $scope.newDownload = ($event) ->
    $mdDialog.show
      templateUrl: "downloads/new.html"
      controller: "NewDownloadController"
      clickOutsideToClose: false
    .then ->
      showToast "Download added."
      $scope.getDownloads()
      
  $scope.deleteDownload = (download, $event) ->
    confirm = $mdDialog.confirm()
      .title("Delete Download")
      .content("Are you sure you want to delete '#{download.url}'?")
      .ok("BE GONE WITH IT!")
      .cancel("No")
      .targetEvent($event)
    $mdDialog.show(confirm).then (() -> 
      Server.service.delete(download).then () -> 
        showToast "Download deleted."
        $scope.getDownloads())  
  $scope.cancelDownload = (download) -> 
    Server.service.cancel(download).then () -> 
      showToast "Download cancelled."
      $scope.getDownloads()
  $scope.queueDownload = (download) -> 
    Server.service.queue(download).then () -> 
      showToast "Download queued."
      $scope.getDownloads()
  $scope.clearDownloads = -> 
    Server.service.clear().then -> 
      showToast "All queues cleared."
      $scope.getDownloads()

  $scope.reorderDownloads = ->
    return unless $scope.selectedIndex == 0
    data = for download, index in $scope.downloads.queued
      download.weight = index
      download
    Server.service.reorder(data).then ()->
      showToast "Queues updated."
      $scope.getDownloads()
]