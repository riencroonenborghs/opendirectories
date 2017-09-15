var app;

app = angular.module("opendirectories.queryTypes.controllers", ["opendirectories.services"]);

app.controller("QueryTypesIndexController", [
  "$scope", "$location", "ChromeStorage", "Topbar", "DEFAULT_SETTINGS", function($scope, $location, ChromeStorage, Topbar, DEFAULT_SETTINGS) {
    Topbar.reset();
    Topbar.linkBackTo("/");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Query Types");
    $scope.queryTypes = {
      "default": $.extend([], DEFAULT_SETTINGS.QUERY_TYPES),
      chrome: []
    };
    ChromeStorage.get("queryTypes").then(function(data) {
      return $scope.queryTypes.storage = data;
    });
    $scope.edit = function(index) {
      return $location.path("/settings/queryTypes/" + index);
    };
    return $scope["delete"] = function(index) {
      $scope.queryTypes.storage.splice(index, 1);
      return ChromeStorage.set("queryTypes", $scope.queryTypes.storage).then(function() {
        return $rootScope.$broadcast("reload.chrome");
      });
    };
  }
]);

app.controller("QueryTypeNewController", [
  "$scope", "$rootScope", "$timeout", "Topbar", "ChromeStorage", function($scope, $rootScope, $timeout, Topbar, ChromeStorage) {
    Topbar.reset();
    Topbar.linkBackTo("/settings/queryTypes");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Query Types");
    Topbar.addSubtitle("Add new");
    $timeout((function() {
      return $(".new-query-type input").focus();
    }), 500);
    $scope.form = {};
    $scope.formLabel = "Add";
    $scope.model = {
      name: "",
      exts: ""
    };
    return $scope.save = function() {
      if (!$scope.form.$invalid) {
        return ChromeStorage.add("queryTypes", $scope.model).then(function() {
          $rootScope.$broadcast("reload.chrome");
          return $scope.visit("/settings/queryTypes");
        });
      }
    };
  }
]);

app.controller("QueryTypeEditController", [
  "$scope", "$rootScope", "$routeParams", "$timeout", "Topbar", "ChromeStorage", function($scope, $rootScope, $routeParams, $timeout, Topbar, ChromeStorage) {
    Topbar.reset();
    Topbar.linkBackTo("/settings/queryTypes");
    Topbar.setTitle("Settings");
    Topbar.addSubtitle("Query Types");
    Topbar.addSubtitle("Edit");
    $scope.form = {};
    $scope.formLabel = "Edit";
    $scope.model = {
      name: "",
      exts: ""
    };
    $scope.queryTypes = [];
    ChromeStorage.get("queryTypes").then(function(data) {
      $scope.queryTypes = data;
      return $scope.model = $scope.queryTypes[$routeParams.index];
    });
    return $scope.save = function() {
      if (!$scope.form.$invalid) {
        $scope.queryTypes[$routeParams.index] = $scope.model;
        return ChromeStorage.set("queryTypes", $scope.queryTypes).then(function() {
          $rootScope.$broadcast("reload.chrome");
          return $scope.visit("/settings/queryTypes");
        });
      }
    };
  }
]);
