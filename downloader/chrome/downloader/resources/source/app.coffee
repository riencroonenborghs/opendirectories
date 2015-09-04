app = angular.module "downloader", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "downloader.server",
  "downloader.auth",
  "downloader.downloads"
]

app.constant "ICONS",
  initial: "cloud_circle"
  queued: "cloud"
  started: "cloud_download"
  finished: "done"
  error: "error"
  cancelled: "cloud_off"

app.config ($authProvider, SERVER, PORT) ->
  $authProvider.configure
    apiUrl: "http://#{SERVER}:#{PORT}"

app.controller "appController", ["$scope", "$rootScope", "$mdMedia", "$http", "$mdDialog", "Server", "$auth",
($scope, $rootScope, $mdMedia, $http, $mdDialog, Server, $auth) ->
  $scope.Server = Server

  # ---------- authentication ----------  
  $scope.user = null
  setUser = (user) ->
    $scope.user = user
    initials = for split in $scope.user.email.split(/@/)
      split[0].toUpperCase()
    $scope.user.initials = initials.slice(0,2).join("")
    
  $auth.validateUser().then (data) ->
    setUser(data)
    $scope.getDownloads()
  , () ->
    $mdDialog.show
      templateUrl: "log-in.html"
      controller: "authController"
      clickOutsideToClose: false
  $scope.logOut = ->
    $auth.signOut().then ->
      $mdDialog.show
        templateUrl: "log-in.html"
        controller: "authController"
        clickOutsideToClose: false

  $rootScope.$on "auth:login-success", (ev, user) ->
    setUser(user)
    $scope.getDownloads()

  $rootScope.$on "auth:logout-success", (ev) ->
    $scope.user = null
    $scope.downloads = []

  # ---------- downloads CRUD ----------
  $rootScope.$on "downloads.get", () ->
    $scope.getDownloads()
  $scope.getDownloads = ->    
    Server.service.get("/api/v1/downloads.json").then (data) -> $scope.downloads = data
  $scope.newDownload = ($event) ->
    $mdDialog.show
      templateUrl: "new-download.html"
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