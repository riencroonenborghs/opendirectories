var Google, app;

app = angular.module("opendirectories.controllers", []);

Google = (function() {
  function Google(model) {
    this.model = model;
    this.server = "https://www.google.com/";
    this.path = "search";
    return;
  }

  Google.prototype.buildUrl = function() {
    return "" + this.server + this.path + "?q=" + (encodeURIComponent(this.buildQuery()));
  };

  Google.prototype.buildQuery = function() {
    var blacklistItem, i, len, queryString, ref;
    queryString = "";
    queryString = this.model.alternative ? "\"parent directory\" " : "intitle:\"index.of\" ";
    queryString += this.model.quoted ? " \"" + this.model.query + "\" " : this.model.query;
    queryString += " -html -htm -php -asp -jsp ";
    ref = this.model.blacklist;
    for (i = 0, len = ref.length; i < len; i++) {
      blacklistItem = ref[i];
      queryString += " -" + blacklistItem;
    }
    return "" + queryString + (this.buildExt());
  };

  Google.prototype.buildExt = function() {
    var queryType;
    queryType = this.model.queryTypes[this.model.queryType];
    if (queryType.exts === "") {
      return "";
    } else {
      return " (" + (queryType.exts.split(',').join("|")) + ") ";
    }
  };

  return Google;

})();

app.controller("appController", [
  "$scope", "$mdMedia", "$mdSidenav", "$timeout", "$location", "DEFAULT_SETTINGS", "Topbar", "ChromeStorage", function($scope, $mdMedia, $mdSidenav, $timeout, $location, DEFAULT_SETTINGS, Topbar, ChromeStorage) {
    var loadFromChrome, resetModel;
    resetModel = function() {
      return $scope.model = {
        query: null,
        queryTypes: $.extend([], DEFAULT_SETTINGS.QUERY_TYPES),
        queryType: 0,
        alternative: false,
        quoted: true,
        incognito: true,
        blacklist: $.extend([], DEFAULT_SETTINGS.BLACKLIST),
        savedQueries: []
      };
    };
    resetModel();
    $scope.Topbar = Topbar;
    Topbar.reset();
    Topbar.setTitle("Opendirectories");
    loadFromChrome = function() {
      resetModel();
      ChromeStorage.get("blacklist").then(function(data) {
        var i, item, len, results;
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          item = data[i];
          results.push($scope.model.blacklist.push(item));
        }
        return results;
      });
      ChromeStorage.get("queryTypes").then(function(data) {
        var i, item, len, results;
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          item = data[i];
          results.push($scope.model.queryTypes.push(item));
        }
        return results;
      });
      return ChromeStorage.get("savedQueries").then(function(data) {
        var i, item, len, results;
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          item = data[i];
          results.push($scope.model.savedQueries.push(item));
        }
        return results;
      });
    };
    loadFromChrome();
    $scope.$on("reload.chrome", function() {
      return loadFromChrome();
    });
    $scope.saveSavedQuery = function() {
      var item;
      item = {
        queryType: $scope.model.queryTypes[$scope.queryType],
        query: $scope.model.query,
        quoted: $scope.model.quoted,
        incognito: $scope.model.incognito,
        alternative: $scope.model.alternative
      };
      return ChromeStorage.add("savedQueries", item).then(function() {
        return loadFromChrome();
      });
    };
    $scope.deleteSavedQuery = function(index) {
      return ChromeStorage.remove("savedQueries", index).then(function() {
        return loadFromChrome();
      });
    };
    $scope.searchSavedQuery = function(savedQuery) {
      var i, index, len, queryType, ref;
      $scope.model.query = savedQuery.query;
      $scope.model.quoted = savedQuery.quoted;
      $scope.model.incognito = savedQuery.incognito;
      $scope.model.alternative = savedQuery.alternative;
      ref = $scope.model.queryTypes;
      for (index = i = 0, len = ref.length; i < len; index = ++i) {
        queryType = ref[index];
        if (queryType === savedQuery.queryType) {
          $scope.model.queryType = index;
        }
      }
      return $scope.search();
    };
    $scope.buildQuery = function() {
      return new Google($scope.model).buildQuery();
    };
    $scope.search = function() {
      if ($scope.model.query) {
        return chrome.windows.create({
          url: new Google($scope.model).buildUrl(),
          incognito: $scope.model.incognito
        });
      }
    };
    $scope.visit = function(url) {
      return $location.path(url);
    };
    return $timeout((function() {
      return $(".search #query").focus();
    }), 500);
  }
]);
