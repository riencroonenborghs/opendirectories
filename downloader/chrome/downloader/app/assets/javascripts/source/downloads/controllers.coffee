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

app.controller "DownloadsController", [ "$scope", "$rootScope", "$mdDialog", "Server", ($scope, $rootScope, $mdDialog, Server) ->
  $scope.downloads = []
  $rootScope.$on "downloads.get", () ->
    $scope.getDownloads()

  $scope.getDownloads = ->
    Server.service.get("/api/v1/downloads.json").then (data) ->
      $scope.downloads = data
  
  $scope.newDownload = ($event) ->
    $mdDialog.show
      templateUrl: "downloads/new.html"
      controller: "NewDownloadController"
      clickOutsideToClose: false
    .then ->
      $scope.getDownloads()
  $scope.deleteDownload = (download, $event) ->
    confirm = $mdDialog.confirm()
      .title("Delete Download")
      .content("Are you sure you want to delete '#{download.url}'?")
      .ok("BE GONE WITH IT!")
      .cancel("No")
      .targetEvent($event)
    $mdDialog.show(confirm).then (() -> Server.service.delete(download).then () -> $scope.getDownloads())  
  $scope.cancelDownload = (download) -> Server.service.cancel(download).then () -> $scope.getDownloads()
  $scope.queueDownload = (download) -> Server.service.queue(download).then () -> $scope.getDownloads()
  $scope.clearDownloads = -> Server.service.clear().then -> $scope.getDownloads()
]