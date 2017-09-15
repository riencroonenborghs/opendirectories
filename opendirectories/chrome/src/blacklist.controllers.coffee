app = angular.module "opendirectories.blacklist.controllers", [
  "opendirectories.services"
]

app.controller "BlacklistIndexController", ["$scope", "$location", "ChromeStorage", "Topbar", "DEFAULT_SETTINGS",
($scope, $location, ChromeStorage, Topbar, DEFAULT_SETTINGS) ->
  Topbar.reset()
  Topbar.linkBackTo "/"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Blacklist"

  $scope.blacklist = {default: $.extend([], DEFAULT_SETTINGS.BLACKLIST), storage: []}
  ChromeStorage.get("blacklist").then (data) -> $scope.blacklist.storage = data

  $scope.edit = (index) -> $location.path "/settings/blacklist/#{index}"
  $scope.delete = (index) -> 
    $scope.blacklist.storage.splice(index, 1)
    ChromeStorage.set("blacklist", $scope.blacklist.storage).then -> $rootScope.$broadcast "reload.chrome"
]

app.controller "BlacklistNewController", ["$scope", "$rootScope", "$timeout", "Topbar", "ChromeStorage", 
($scope, $rootScope, $timeout, Topbar, ChromeStorage) ->
  Topbar.reset()
  Topbar.linkBackTo "/settings/blacklist"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Blacklist"
  Topbar.addSubtitle "Add new"

  $timeout (-> $(".new-blacklist input").focus()), 500

  $scope.form = {}
  $scope.formLabel = "Add"

  $scope.model = {url: ""}
  $scope.save = ->
    if !$scope.form.$invalid
      ChromeStorage.add("blacklist", $scope.model.url).then -> 
        $rootScope.$broadcast "reload.chrome"
        $scope.visit "/settings/blacklist"
]

app.controller "BlacklistEditController", ["$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ChromeStorage",
($scope, $rootScope, $routeParams, $timeout, Topbar, ChromeStorage) ->
  Topbar.reset()
  Topbar.linkBackTo "/settings/blacklist"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Blacklist"
  Topbar.addSubtitle "Edit"

  $scope.form = {}
  $scope.formLabel = "Edit"

  $scope.model = {url: ""}
  $scope.blacklist = []
  ChromeStorage.get("blacklist").then (data) ->
    $scope.blacklist = data
    $scope.model.url = $scope.blacklist[$routeParams.index]

  $scope.save = ->
    if !$scope.form.$invalid 
      $scope.blacklist[$routeParams.index] = $scope.model.url
      ChromeStorage.set("blacklist", $scope.blacklist).then ->
        $rootScope.$broadcast "reload.chrome"
        $scope.visit "/settings/blacklist"
]