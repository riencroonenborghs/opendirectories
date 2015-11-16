app = angular.module "opendirectories.menu.controllers", []

app.controller "menuController", ["$scope", "$mdSidenav", 
($scope, $mdSidenav) ->
  $scope.close = -> $mdSidenav('right').close()
  $scope.blacklist  = false
  $scope.queryTypes = false
  $scope.showBlacklist   = -> $scope.blacklist = true
  $scope.showQueryTypes  = -> $scope.queryTypes = true
  $scope.showLinks = -> 
    $scope.blacklist = false
    $scope.queryTypes = false
]  