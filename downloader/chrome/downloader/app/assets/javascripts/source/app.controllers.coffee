app = angular.module "downloader.controllers", [
  "downloader.constants"
]

app.controller "appController", ["$scope", "$rootScope", "$mdDialog", "$controller", "Server", "ICONS",
($scope, $rootScope, $mdDialog, $controller, Server, ICONS) ->
  $scope.Server = Server
  
  $controller "AuthController", $scope: $scope
  $controller "DownloadsController", $scope: $scope
  
  $scope.tabs = for label, icon of ICONS
    {title: label, icon: icon}
  $scope.selectedIndex = 0
]