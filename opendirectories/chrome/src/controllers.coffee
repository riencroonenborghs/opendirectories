app = angular.module "opendirectories.controllers", []

app.controller "appController", ["$scope", "$mdSidenav", "$timeout", "$location", "GoogleSearchModelService", "Topbar", "ChromeStorage", "$rootScope", "GoogleSearchService", "GoogleQueryFactory",
($scope, $mdSidenav, $timeout, $location, GoogleSearchModelService, Topbar, ChromeStorage, $rootScope, GoogleSearchService, GoogleQueryFactory) ->
  # router loads appController again
  # don't want to set the searchModel twice (and load everything twice)
  unless $scope.searchModel
    $scope.searchModel = GoogleSearchModelService
    $scope.searchModel.loadFromChrome()
  
  $scope.Topbar = Topbar
  Topbar.reset()
  Topbar.setTitle "Opendirectories"

  $scope.$on "reload.chrome", -> $scope.searchModel.loadFromChrome()

  $scope.saveSavedQuery = ->
    item =
      queryType:    $scope.searchModel.model.queryTypes[$scope.queryType]
      query:        $scope.searchModel.model.query
      quoted:       $scope.searchModel.model.quoted
      incognito:    $scope.searchModel.model.incognito
      alternative:  $scope.searchModel.model.alternative
    ChromeStorage.add("savedQueries", item).then -> 
      $scope.searchModel.clearList "savedQueries"
      $scope.searchModel.loadFromChrome()
      $scope.openSavedQueries()
  $scope.openSavedQueries = -> $mdSidenav("savedQueries").toggle()
  $scope.closeSavedQueries = -> $mdSidenav("savedQueries").close()
  
  $scope.search = -> GoogleSearchService.search($scope.searchModel.model)
  $scope.buildQuery = -> $scope.googleQuery = new GoogleQueryFactory($scope.searchModel.model).buildQuery()
  
  $scope.visit = (url) -> $location.path url

  $timeout (-> $(".search #query").focus()), 500
]  

app.controller "SavedQueriesController", [ "$scope", "GoogleSearchService", "ChromeStorage", "GoogleSearchModelService",
($scope, GoogleSearchService, ChromeStorage, GoogleSearchModelService) ->  
  $scope.deleteSavedQuery = (index) ->
    ChromeStorage.remove("savedQueries", index).then -> 
      $scope.searchModel.clearList "savedQueries"
      ChromeStorage.get("savedQueries").then (data) ->
        for item in data
          $scope.searchModel.addToList "savedQueries", item

  $scope.searchSavedQuery = (savedQuery) ->
    searchModel = GoogleSearchModelService
    searchModel.model.query        = savedQuery.query
    searchModel.model.quoted       = savedQuery.quoted
    searchModel.model.incognito    = savedQuery.incognito
    searchModel.model.alternative  = savedQuery.alternative
    for queryType,index in searchModel.model.queryTypes when queryType == savedQuery.queryType
      searchModel.model.queryType = index
    GoogleSearchService.search(searchModel.model)
]