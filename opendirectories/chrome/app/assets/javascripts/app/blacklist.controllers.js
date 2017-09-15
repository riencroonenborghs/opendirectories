var app;

app = angular.module("opendirectories.blacklist.controllers", ["opendirectories.services"]);

app.controller("BlacklistIndexController", [
  "$scope", "$location", "ChromeStorage", "Topbar", "DEFAULT_SETTINGS", function($scope, $location, ChromeStorage, Topbar, DEFAULT_SETTINGS) {
    Topbar.reset();
    Topbar.linkBackTo("/");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Blacklist");
    $scope.blacklist = {
      "default": $.extend([], DEFAULT_SETTINGS.BLACKLIST),
      storage: []
    };
    ChromeStorage.get("blacklist").then(function(data) {
      return $scope.blacklist.storage = data;
    });
    $scope.edit = function(index) {
      return $location.path("/settings/blacklist/" + index);
    };
    return $scope["delete"] = function(index) {
      $scope.blacklist.storage.splice(index, 1);
      return ChromeStorage.set("blacklist", $scope.blacklist.storage).then(function() {
        return $rootScope.$broadcast("reload.chrome");
      });
    };
  }
]);

app.controller("BlacklistNewController", [
  "$scope", "$rootScope", "$timeout", "Topbar", "ChromeStorage", function($scope, $rootScope, $timeout, Topbar, ChromeStorage) {
    Topbar.reset();
    Topbar.linkBackTo("/settings/blacklist");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Blacklist");
    Topbar.addSubtitle("Add new");
    $timeout((function() {
      return $(".new-blacklist input").focus();
    }), 500);
    $scope.form = {};
    $scope.formLabel = "Add";
    $scope.model = {
      url: ""
    };
    return $scope.save = function() {
      if (!$scope.form.$invalid) {
        return ChromeStorage.add("blacklist", $scope.model.url).then(function() {
          $rootScope.$broadcast("reload.chrome");
          return $scope.visit("/settings/blacklist");
        });
      }
    };
  }
]);

app.controller("BlacklistEditController", [
  "$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ChromeStorage", function($scope, $rootScope, $routeParams, $timeout, Topbar, ChromeStorage) {
    Topbar.reset();
    Topbar.linkBackTo("/settings/blacklist");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Blacklist");
    Topbar.addSubtitle("Edit");
    $scope.form = {};
    $scope.formLabel = "Edit";
    $scope.model = {
      url: ""
    };
    $scope.blacklist = [];
    ChromeStorage.get("blacklist").then(function(data) {
      $scope.blacklist = data;
      return $scope.model.url = $scope.blacklist[$routeParams.index];
    });
    return $scope.save = function() {
      if (!$scope.form.$invalid) {
        $scope.blacklist[$routeParams.index] = $scope.model.url;
        return ChromeStorage.set("blacklist", $scope.blacklist).then(function() {
          $rootScope.$broadcast("reload.chrome");
          return $scope.visit("/settings/blacklist");
        });
      }
    };
  }
]);
