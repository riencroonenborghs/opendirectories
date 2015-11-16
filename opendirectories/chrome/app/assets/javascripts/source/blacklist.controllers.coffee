app = angular.module "opendirectories.blacklist.controllers", [
  "opendirectories.services"
]

app.controller "blacklistController", ["$scope", "$rootScope", "DEFAULT_BLACKLIST", "ListService",
($scope, $rootScope, DEFAULT_BLACKLIST, ListService) ->
  $scope.blacklist = DEFAULT_BLACKLIST
  chrome.storage.sync.get "blacklist", (data) ->
    if data.blacklist
      $scope.blacklist = JSON.parse data.blacklist
  
  $scope.model = {url: null}
  $scope.add = ->
    if $scope.model.url
      $scope.blacklist.push $scope.model.url
      $scope.model = {url: null}
      ListService.service.store "blacklist", $scope.blacklist
      $rootScope.$broadcast "reload.chrome"
  $scope.remove = (item) -> 
    ListService.service.removeAndStore "blacklist", $scope.blacklist, item
    $rootScope.$broadcast "reload.chrome"
]