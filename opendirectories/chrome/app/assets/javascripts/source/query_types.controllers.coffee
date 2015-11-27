app = angular.module "opendirectories.queryTypes.controllers", [
  "opendirectories.services"
]

app.controller "QueryTypesIndexController", ["$scope", "DEFAULT_QUERY_TYPES", "ListService", "Topbar", ($scope, DEFAULT_QUERY_TYPES, ListService, Topbar) ->
  Topbar.reset()
  Topbar.linkBackTo "/"
  Topbar.setTitle "Settings"
  Topbar.addSubtitle "Query Types"

  # $scope.queryTypes = DEFAULT_QUERY_TYPES
  # chrome.storage.sync.get "queryTypes", (data) ->
  #   if data.queryTypes
  #     $scope.queryTypes = JSON.parse data.queryTypes

  # $scope.edit = (index) -> 
  # $scope.delete = (index) -> 
  #   ListService.service.removeAndStore $scope.queryTypes, "queryTypes", index
  #   $rootScope.$broadcast "reload.chrome"
]

# app.controller "queryTypesController", ["$scope", "$rootScope", "DEFAULT_QUERY_TYPES", "ListService",
# ($scope, $rootScope, DEFAULT_QUERY_TYPES, ListService) ->
#   $scope.queryTypes = DEFAULT_QUERY_TYPES
#   chrome.storage.sync.get "queryTypes", (data) ->
#     if data.queryTypes
#       $scope.queryTypes = JSON.parse data.queryTypes

#   $scope.model = {name: null, exts: null}
#   $scope.add = ->
#     if $scope.model.name && $scope.model.exts
#       $scope.queryTypes.push {name: $scope.model.name, exts: $scope.model.exts}
#       $scope.model = {name: null, exts: null}
#       ListService.service.store "queryTypes", $scope.queryTypes
#       $rootScope.$broadcast "reload.chrome"
#   $scope.remove = (item) -> 
#     ListService.service.removeAndStore "queryTypes", $scope.queryTypes, item
#     $rootScope.$broadcast "reload.chrome"
# ]