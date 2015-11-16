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


app.controller "appController", ["$scope", "$mdMedia", "$mdSidenav", "DEFAULT_BLACKLIST", "DEFAULT_QUERY_TYPES",
($scope, $mdMedia, $mdSidenav, DEFAULT_BLACKLIST, DEFAULT_QUERY_TYPES) ->
  $scope.model =
    query:        null
    queryTypes:   DEFAULT_QUERY_TYPES
    queryType:    0
    alternative:  false
    quoted:       true
    incognito:    true
    blacklist:    DEFAULT_BLACKLIST

  loadFromChrome = ->
    chrome.storage.sync.get "blacklist", (data) ->
      if data.blacklist
        $scope.model.blacklist = JSON.parse data.blacklist      
    chrome.storage.sync.get "queryTypes", (data) ->
      if data.queryTypes
        $scope.model.queryTypes = JSON.parse data.queryTypes
  loadFromChrome()
  $scope.$on "reload.chrome", -> loadFromChrome()

  $scope.buildQuery = ->
    new Google($scope.model).buildQuery()
  $scope.search = ->
    if $scope.model.query
      chrome.windows.create
        url: new Google($scope.model).buildUrl(),
        incognito: $scope.model.incognito

  $scope.showMenu = -> $mdSidenav('right').toggle()
]  