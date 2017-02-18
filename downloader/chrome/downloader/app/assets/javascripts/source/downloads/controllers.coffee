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

  showToast = (message) ->
    $mdToast.show($mdToast.simple().textContent(message).hideDelay(3000))

  $scope.downloads = []
  $rootScope.$on "downloads.get", () ->
    $scope.getDownloads()

  $scope.getDownloads = ->
    Server.service.get("/api/v1/downloads.json").then (data) ->
      $scope.downloads = data
      for download in $scope.downloads.items
        download.visible = false
  
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
    for download, index in $scope.downloads.items
      download.weight = index
    Server.service.reorder($scope.downloads.items).then ()->
      showToast "Queues updated."
      $scope.getDownloads()
]