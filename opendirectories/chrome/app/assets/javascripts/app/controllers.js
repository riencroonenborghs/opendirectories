var app;

app = angular.module("opendirectories.controllers", []);

app.controller("appController", [
  "$scope", "$mdSidenav", "$timeout", "$location", "GoogleSearchModelService", "Topbar", "ChromeStorage", "$rootScope", "GoogleSearchService", "GoogleQueryFactory", function($scope, $mdSidenav, $timeout, $location, GoogleSearchModelService, Topbar, ChromeStorage, $rootScope, GoogleSearchService, GoogleQueryFactory) {
    if (!$scope.searchModel) {
      $scope.searchModel = GoogleSearchModelService;
      $scope.searchModel.loadFromChrome();
    }
    $scope.Topbar = Topbar;
    Topbar.reset();
    Topbar.setTitle("Opendirectories");
    $scope.$on("reload.chrome", function() {
      return $scope.searchModel.loadFromChrome();
    });
    $scope.saveSavedQuery = function() {
      var item;
      item = {
        queryType: $scope.searchModel.model.queryTypes[$scope.queryType],
        query: $scope.searchModel.model.query,
        quoted: $scope.searchModel.model.quoted,
        incognito: $scope.searchModel.model.incognito,
        alternative: $scope.searchModel.model.alternative
      };
      return ChromeStorage.add("savedQueries", item).then(function() {
        $scope.searchModel.clearList("savedQueries");
        $scope.searchModel.loadFromChrome();
        return $scope.openSavedQueries();
      });
    };
    $scope.openSavedQueries = function() {
      return $mdSidenav("savedQueries").toggle();
    };
    $scope.closeSavedQueries = function() {
      return $mdSidenav("savedQueries").close();
    };
    $scope.search = function() {
      return GoogleSearchService.search($scope.searchModel.model);
    };
    $scope.buildQuery = function() {
      return $scope.googleQuery = new GoogleQueryFactory($scope.searchModel.model).buildQuery();
    };
    $scope.visit = function(url) {
      return $location.path(url);
    };
    return $timeout((function() {
      return $(".search #query").focus();
    }), 500);
  }
]);

app.controller("SavedQueriesController", [
  "$scope", "GoogleSearchService", "ChromeStorage", "GoogleSearchModelService", function($scope, GoogleSearchService, ChromeStorage, GoogleSearchModelService) {
    $scope.deleteSavedQuery = function(index) {
      return ChromeStorage.remove("savedQueries", index).then(function() {
        $scope.searchModel.clearList("savedQueries");
        return ChromeStorage.get("savedQueries").then(function(data) {
          var i, item, len, results;
          results = [];
          for (i = 0, len = data.length; i < len; i++) {
            item = data[i];
            results.push($scope.searchModel.addToList("savedQueries", item));
          }
          return results;
        });
      });
    };
    return $scope.searchSavedQuery = function(savedQuery) {
      var i, index, len, queryType, ref, searchModel;
      searchModel = GoogleSearchModelService;
      searchModel.model.query = savedQuery.query;
      searchModel.model.quoted = savedQuery.quoted;
      searchModel.model.incognito = savedQuery.incognito;
      searchModel.model.alternative = savedQuery.alternative;
      ref = searchModel.model.queryTypes;
      for (index = i = 0, len = ref.length; i < len; index = ++i) {
        queryType = ref[index];
        if (queryType === savedQuery.queryType) {
          searchModel.model.queryType = index;
        }
      }
      return GoogleSearchService.search(searchModel.model);
    };
  }
]);
