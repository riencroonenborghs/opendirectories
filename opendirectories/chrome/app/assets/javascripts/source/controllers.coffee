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


app.controller "appController", ["$scope", "$mdMedia", "$mdSidenav", "$timeout", "$location", "DEFAULT_SETTINGS", "Topbar",
($scope, $mdMedia, $mdSidenav, $timeout, $location, DEFAULT_SETTINGS, Topbar) ->
  $scope.model =
    query:        null
    queryTypes:   $.extend([], DEFAULT_SETTINGS.QUERY_TYPES)
    queryType:    0
    alternative:  false
    quoted:       true
    incognito:    true
    blacklist:    $.extend([], DEFAULT_SETTINGS.BLACKLIST)
  
  $scope.Topbar = Topbar
  Topbar.reset()
  Topbar.setTitle "Opendirectories"

  # chrome.storage.local.clear()
  loadFromChrome = ->
    chrome.storage.local.get "blacklist", (data) ->
      if data.blacklist
        for item in JSON.parse(data.blacklist)
          $scope.model.blacklist.push item
    chrome.storage.local.get "queryTypes", (data) ->
      if data.queryTypes
        for item in JSON.parse(data.queryTypes)
          $scope.model.queryTypes.push item
  loadFromChrome()
  $scope.$on "reload.chrome", -> loadFromChrome()

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