var app;

app = angular.module("downloader.controllers", []);

app.controller("AppController", [
  "$scope", "$rootScope", "$controller", "Server", "ICONS", function($scope, $rootScope, $controller, Server, ICONS) {
    var icon, label;
    $scope.Server = Server;
    $controller("AuthController", {
      $scope: $scope
    });
    $controller("DownloadsController", {
      $scope: $scope
    });
    $scope.tabs = (function() {
      var results;
      results = [];
      for (label in ICONS) {
        icon = ICONS[label];
        results.push({
          title: label,
          icon: icon
        });
      }
      return results;
    })();
    return $scope.selectedIndex = 0;
  }
]);
