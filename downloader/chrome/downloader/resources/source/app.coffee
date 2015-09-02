app = angular.module "downloader", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "downloader.auth",
  "downloader.downloads"
]

icons =
  initial: "cloud_circle"
  queued: "cloud"
  started: "cloud_download"
  finished: "done"
  error: "error"
  cancelled: "cloud_off"
debug = true

app.constant "SERVER", "localhost"
app.constant "PORT", 3000
app.factory "Server", [ "SERVER", "PORT", (SERVER, PORT) ->
  service:
    toString: -> "http://#{SERVER}:#{PORT}"
    build: (path) -> "http://#{SERVER}:#{PORT}#{path}"
] 

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
    $http
      method: "GET"
      url: Server.service.build("/api/v1/downloads.json")
      dataType: "jsonp"
    .success (data) -> 
      data.items = for item in data.items
        item = JSON.parse(item)
        item.visible = false
        item.icon = icons[item.status]
        item.hasPointer = (item.status != "initial" && item.status != "queued")
        item.canDelete = (item.status != "started" && item.status != "queued")
        item.canCancel = (item.status == "queued")
        item.canQueue = (item.status == "initial" || item.status == "finished" || item.status == "error" || item.status == "cancelled")
        item
      $scope.downloads = data

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
    $mdDialog.show(confirm).then (() -> deleteDownload(download)), () -> $scope.getDownloads()
  
  deleteDownload = (download) ->
    return unless download.canDelete
    $http
      method: "DELETE"
      url: Server.service.build("/api/v1/downloads/#{download.id}")
      dataType: "jsonp"
    .success () -> $scope.getDownloads()

  $scope.cancelDownload = (download) ->
    return unless download.canCancel
    $http
      method: "PUT"
      url: Server.service.build("/api/v1/downloads/#{download.id}/cancel")
      dataType: "jsonp"
    .success () -> $scope.getDownloads()

  $scope.queueDownload = (download) ->
    return unless download.canQueue
    $http
      method: "PUT"
      url: Server.service.build("/api/v1/downloads/#{download.id}/queue")
      dataType: "jsonp"
    .success () -> $scope.getDownloads()
]