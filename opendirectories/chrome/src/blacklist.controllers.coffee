app = angular.module "opendirectories.blacklist.controllers", [
  "opendirectories.services"
]

app.controller "BlacklistIndexController", ["$scope", "$location", "ListService", "Topbar", "DEFAULT_SETTINGS",
($scope, $location, ListService, Topbar, DEFAULT_SETTINGS) ->
  Topbar.reset()
  Topbar.linkBackTo "/"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Blacklist"

  $scope.blacklist = {default: $.extend([], DEFAULT_SETTINGS.BLACKLIST), chrome: []}
  chrome.storage.local.get "blacklist", (data) ->
    if data.blacklist
      $scope.blacklist.chrome = JSON.parse data.blacklist

  $scope.edit = (index) -> $location.path "/settings/blacklist/#{index}"
  $scope.delete = (index) -> 
    ListService.service.removeAndStore $scope.blacklist.chrome, "blacklist", index
    $rootScope.$broadcast "reload.chrome"
]

app.controller "BlacklistNewController", ["$scope", "$rootScope", "$timeout", "Topbar", "ListService", 
($scope, $rootScope, $timeout, Topbar, ListService) ->
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
      ListService.service.addToList "blacklist", $scope.model.url
      $rootScope.$broadcast "reload.chrome"
      $timeout (->$scope.visit("/settings/blacklist")), 500
]

app.controller "BlacklistEditController", ["$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ListService",
($scope, $rootScope, $routeParams, $timeout, Topbar, ListService) ->
  Topbar.reset()
  Topbar.linkBackTo "/settings/blacklist"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Blacklist"
  Topbar.addSubtitle "Edit"

  $scope.form = {}
  $scope.formLabel = "Edit"

  $scope.model = {url: ""}
  $scope.blacklist = []
  chrome.storage.local.get "blacklist", (data) ->
    if data.blacklist
      $scope.blacklist = JSON.parse data.blacklist
      $scope.model.url = $scope.blacklist[$routeParams.index]

  $scope.save = ->
    if !$scope.form.$invalid      
      ListService.service.update $scope.blacklist, "blacklist", $scope.model.url, $routeParams.index
      $rootScope.$broadcast "reload.chrome"
      $timeout (->$scope.visit("/settings/blacklist")), 500
]