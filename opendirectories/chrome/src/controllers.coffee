app = angular.module "opendirectories.controllers", []

class Google
  constructor: (@model) ->
    @server = "https://www.google.com/"
    @path   = "search"
    return
  buildUrl: -> "#{@server}#{@path}?q=#{encodeURIComponent(@buildQuery())}"
  buildQuery: ->
    queryString = ""
    queryString = if @model.alternative then "\"parent directory\" " else "intitle:\"index.of\" "
    queryString += if @model.quoted then " \"#{@model.query}\" " else @model.query
    queryString += " -html -htm -php -asp -jsp "
    for blacklistItem in @model.blacklist
      queryString += " -" + blacklistItem
    "#{queryString}#{@buildExt()}"
  buildExt: ->
    queryType = @model.queryTypes[@model.queryType]
    if queryType.exts == "" then "" else " (#{queryType.exts.split(',').join("|")}) "


app.controller "appController", ["$scope", "$mdMedia", "$mdSidenav", "$timeout", "$location", "DEFAULT_SETTINGS", "Topbar", "ChromeStorage",
($scope, $mdMedia, $mdSidenav, $timeout, $location, DEFAULT_SETTINGS, Topbar, ChromeStorage) ->
  resetModel = ->
    $scope.model =
      query:        null
      queryTypes:   $.extend([], DEFAULT_SETTINGS.QUERY_TYPES)
      queryType:    0
      alternative:  false
      quoted:       true
      incognito:    true
      blacklist:    $.extend([], DEFAULT_SETTINGS.BLACKLIST)
      savedQueries: []
  resetModel()
  
  $scope.Topbar = Topbar
  Topbar.reset()
  Topbar.setTitle "Opendirectories"

  # chrome.storage.local.clear()
  loadFromChrome = ->
    resetModel()
    ChromeStorage.get("blacklist").then (data) ->
      for item in data
        $scope.model.blacklist.push item
    ChromeStorage.get("queryTypes").then (data) ->
      for item in data
        $scope.model.queryTypes.push item
    ChromeStorage.get("savedQueries").then (data) ->
      for item in data
        $scope.model.savedQueries.push item
  loadFromChrome()
  $scope.$on "reload.chrome", -> loadFromChrome()

  # saved queries
  $scope.saveSavedQuery = ->
    item =
      queryType: $scope.model.queryTypes[$scope.queryType]
      query: $scope.model.query
      quoted: $scope.model.quoted
      incognito: $scope.model.incognito
      alternative: $scope.model.alternative
    ChromeStorage.add("savedQueries", item).then -> loadFromChrome()
  $scope.deleteSavedQuery = (index) ->
    ChromeStorage.remove("savedQueries", index).then -> loadFromChrome()
  $scope.searchSavedQuery = (savedQuery) ->
    $scope.model.query = savedQuery.query
    $scope.model.quoted = savedQuery.quoted
    $scope.model.incognito = savedQuery.incognito
    $scope.model.alternative = savedQuery.alternative
    for queryType,index in $scope.model.queryTypes when queryType == savedQuery.queryType
      $scope.model.queryType = index
    $scope.search()

  $scope.buildQuery = ->
    new Google($scope.model).buildQuery()
  $scope.search = ->
    if $scope.model.query
      chrome.windows.create
        url: new Google($scope.model).buildUrl(),
        incognito: $scope.model.incognito
  
  $scope.visit = (url) -> $location.path url

  $timeout (-> $(".search #query").focus()), 500
]  