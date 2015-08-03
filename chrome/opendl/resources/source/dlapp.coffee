app = angular.module "opendl", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "opendl.auth"
]

icons = {initial: "cloud_circle", queued: "cloud", busy: "cloud_download", done: "done", error: "error"}
debug        = true

app.service "Logging", [->
  debug: (message) ->
    console.debug message if debug
]

app.factory "Server", [->
  service:
    server: "localhost"
    port: 3000
    build: (path) ->
      "http://#{@server}:#{@port}#{path}"
] 

app.config ($authProvider) ->
  $authProvider.configure
    apiUrl: "http://localhost:3000"

app.controller "appController", ["$scope", "$rootScope", "$mdMedia", "$http", "$mdDialog", "Server", "Logging", "$auth",
($scope, $rootScope, $mdMedia, $http, $mdDialog, Server, Logging, $auth) ->
  # ---------- authentication ----------
  $scope.path = "Authenticate"
  $auth.validateUser().then (data) ->
    $scope.getDownloads()
  , () ->
    $mdDialog.show
      templateUrl: "log-in.html"
      controller: "authController"
      clickOutsideToClose: false
  $scope.logOut = ->
    $auth.signOut().then ->
      $scope.downloads = []
      $mdDialog.show
        templateUrl: "log-in.html"
        controller: "authController"
        clickOutsideToClose: false

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
      $.map data.items, (e,i) -> 
        e.visible = false
        e.icon = icons[e.status]

      $scope.downloads = data

  $scope.newDownload = ($event) ->
    $scope.path = "New Download"
    $mdDialog.show
      templateUrl: "new-download.html"
      controller: "DialogController"
      clickOutsideToClose: true
    .then ->
      $scope.getDownloads()

  $scope.deleteDownload = (download, $event) ->
    $scope.path = "Delete Download"
    confirm = $mdDialog.confirm()
      .title("Delete Download")
      .content("Are you sure you want to delete '#{download.url}'?")
      .ok('BE GONE WITH IT!')
      .cancel('No')
      .targetEvent($event)
    $mdDialog.show(confirm).then (() -> deleteDownload(download)), () -> $scope.getDownloads()
  
  deleteDownload = (download) ->
    $http
      method: "DELETE"
      url: Server.service.build("/api/v1/downloads/#{download.id}")
      dataType: "jsonp"
    .success () -> $scope.getDownloads()

]

app.controller "DialogController", ["$scope", "$rootScope", "$mdDialog", "$http", "Server", "Logging",
($scope, $rootScope, $mdDialog, $http, Server, Logging) ->
  $scope.model = {url: "", http_username: "", http_password: ""}
  $scope.save = () ->
    Logging.debug "post"
    data = {download: $scope.model}
    $http
      method: "POST"
      url: Server.service.build("/api/v1/downloads?#{$.param(data)}")
    .success () ->
      $rootScope.$broadcast("reload");
      $mdDialog.hide()
      return
  $scope.close = -> $mdDialog.hide()
]
