app = angular.module "opendl-downloader", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "opendl-downloader.auth"
]

icons = {initial: "cloud_circle", queued: "cloud", started: "cloud_download", finished: "done", error: "error", cancelled: "cloud_off"}
debug = true

app.service "Logging", [->
  debug: (message) ->
    console.debug message if debug
]

server = "localhost"
port = 3000

app.factory "Server", [->
  service:
    toString: -> "http://#{@server}:#{@port}"
    server: server
    port: port
    build: (path) ->
      "http://#{@server}:#{@port}#{path}"
] 

app.config ($authProvider) ->
  $authProvider.configure
    apiUrl: "http://#{server}:#{port}"

app.controller "appController", ["$scope", "$rootScope", "$mdMedia", "$http", "$mdDialog", "Server", "Logging", "$auth",
($scope, $rootScope, $mdMedia, $http, $mdDialog, Server, Logging, $auth) ->
  $scope.Server = Server
  # ---------- authentication ----------
  $scope.path = "Authenticate"
  $scope.user = null

  parseInitials = ->
    initials = for split in $scope.user.email.split(/@/)
      split[0].toUpperCase()
    $scope.user.initials = initials.slice(0,2).join("")

  $auth.validateUser().then (data) ->
    $scope.user = data
    parseInitials()
    $scope.getDownloads()
  , () ->
    $mdDialog.show
      templateUrl: "log-in.html"
      controller: "authController"
      clickOutsideToClose: false
  $scope.logOut = ->
    $auth.signOut().then ->
      $scope.downloads = []
      $scope.user = null
      $mdDialog.show
        templateUrl: "log-in.html"
        controller: "authController"
        clickOutsideToClose: false
  $rootScope.$on "auth:login-success", (ev, user) ->
    console.debug user
    $scope.user = user
    parseInitials()

  # ---------- downloads CRUD ----------
  $rootScope.$on "reload", () ->
    $scope.getDownloads()
  $scope.getDownloads = ->    
    $scope.path = "Downloads"
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
    $scope.path = "New Download"
    $mdDialog.show
      templateUrl: "new-download.html"
      controller: "DialogController"
      clickOutsideToClose: false
    .then ->
      $scope.getDownloads()

  $scope.deleteDownload = (download, $event) ->
    $scope.path = "Delete Download"
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

app.controller "DialogController", ["$scope", "$rootScope", "$mdDialog", "$http", "Server", "Logging",
($scope, $rootScope, $mdDialog, $http, Server, Logging) ->
  $scope.model = {url: "", http_username: "", http_password: ""}
  $scope.forms = {}
  $scope.error = null
  $scope.save = () ->
    Logging.debug "post"
    data = {download: $scope.model}
    $http
      method: "POST"
      url: Server.service.build("/api/v1/downloads.json")
      data: data
    .then () ->
      $rootScope.$broadcast("reload")
      $rootScope.$emit("reload")
      $mdDialog.hide()
      return
    , (message) ->      
      $scope.error = message.data.error
      return
  $scope.close = -> $mdDialog.hide()
]
