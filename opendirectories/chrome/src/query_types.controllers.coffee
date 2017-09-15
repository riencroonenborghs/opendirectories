app = angular.module "opendirectories.queryTypes.controllers", [
  "opendirectories.services"
]

app.controller "QueryTypesIndexController", ["$scope", "$location", "ChromeStorage", "Topbar", "DEFAULT_SETTINGS",
($scope, $location, ChromeStorage, Topbar, DEFAULT_SETTINGS) ->
  Topbar.reset()
  Topbar.linkBackTo "/"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Query Types"

  $scope.queryTypes = {default: $.extend([], DEFAULT_SETTINGS.QUERY_TYPES), chrome: []}
  ChromeStorage.get("queryTypes").then (data) -> $scope.queryTypes.storage = data

  $scope.edit = (index) -> $location.path "/settings/queryTypes/#{index}"
  $scope.delete = (index) -> 
    $scope.queryTypes.storage.splice(index, 1)
    ChromeStorage.set("queryTypes", $scope.queryTypes.storage).then -> $rootScope.$broadcast "reload.chrome"
]

app.controller "QueryTypeNewController", ["$scope", "$rootScope", "$timeout", "Topbar", "ChromeStorage", 
($scope, $rootScope, $timeout, Topbar, ChromeStorage) ->
  Topbar.reset()
  Topbar.linkBackTo "/settings/queryTypes"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Query Types"
  Topbar.addSubtitle "Add new"

  $timeout (-> $(".new-query-type input").focus()), 500

  $scope.form = {}
  $scope.formLabel = "Add"

  $scope.model = {name: "", exts: ""}
  $scope.save = ->
    if !$scope.form.$invalid
      ChromeStorage.add("queryTypes", $scope.model).then -> 
        $rootScope.$broadcast "reload.chrome"
        $scope.visit "/settings/queryTypes"
]

app.controller "QueryTypeEditController", ["$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ChromeStorage",
($scope, $rootScope, $routeParams, $timeout, Topbar, ChromeStorage) ->
  Topbar.reset()
  Topbar.linkBackTo "/settings/queryTypes"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Query Types"
  Topbar.addSubtitle "Edit"

  $scope.form = {}
  $scope.formLabel = "Edit"

  $scope.model = {name: "", exts: ""}
  $scope.queryTypes = []
  ChromeStorage.get("queryTypes").then (data) ->
    $scope.queryTypes = data
    $scope.model = $scope.queryTypes[$routeParams.index]

  $scope.save = ->
    if !$scope.form.$invalid   
      $scope.queryTypes[$routeParams.index] = $scope.model
      ChromeStorage.set("queryTypes", $scope.queryTypes).then ->
        $rootScope.$broadcast "reload.chrome"
        $scope.visit "/settings/queryTypes"
]