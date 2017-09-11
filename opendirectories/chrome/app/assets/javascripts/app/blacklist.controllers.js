var app;

app = angular.module("opendirectories.blacklist.controllers", ["opendirectories.services"]);

app.controller("BlacklistIndexController", [
  "$scope", "$location", "ListService", "Topbar", "DEFAULT_SETTINGS", function($scope, $location, ListService, Topbar, DEFAULT_SETTINGS) {
    Topbar.reset();
    Topbar.linkBackTo("/");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Blacklist");
    $scope.blacklist = {
      "default": $.extend([], DEFAULT_SETTINGS.BLACKLIST),
      chrome: []
    };
    chrome.storage.local.get("blacklist", function(data) {
      if (data.blacklist) {
        return $scope.blacklist.chrome = JSON.parse(data.blacklist);
      }
    });
    $scope.edit = function(index) {
      return $location.path("/settings/blacklist/" + index);
    };
    return $scope["delete"] = function(index) {
      ListService.service.removeAndStore($scope.blacklist.chrome, "blacklist", index);
      return $rootScope.$broadcast("reload.chrome");
    };
  }
]);

app.controller("BlacklistNewController", [
  "$scope", "$rootScope", "$timeout", "Topbar", "ListService", function($scope, $rootScope, $timeout, Topbar, ListService) {
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
        ListService.service.addToList("blacklist", $scope.model.url);
        $rootScope.$broadcast("reload.chrome");
        return $timeout((function() {
          return $scope.visit("/settings/blacklist");
        }), 500);
      }
    };
  }
]);

app.controller("BlacklistEditController", [
  "$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ListService", function($scope, $rootScope, $routeParams, $timeout, Topbar, ListService) {
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
    chrome.storage.local.get("blacklist", function(data) {
      if (data.blacklist) {
        $scope.blacklist = JSON.parse(data.blacklist);
        return $scope.model.url = $scope.blacklist[$routeParams.index];
      }
    });
    return $scope.save = function() {
      if (!$scope.form.$invalid) {
        ListService.service.update($scope.blacklist, "blacklist", $scope.model.url, $routeParams.index);
        $rootScope.$broadcast("reload.chrome");
        return $timeout((function() {
          return $scope.visit("/settings/blacklist");
        }), 500);
      }
    };
  }
]);
