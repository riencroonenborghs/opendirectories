var app;

app = angular.module("opendirectories.services", []);

app.service("ChromeStorage", [
  "$q", function($q) {
    var service;
    service = {
      set: function(key, data) {
        var _data, deferred;
        _data = {};
        _data[key] = JSON.stringify(data);
        deferred = $q.defer();
        chrome.storage.local.set(_data, function() {
          return deferred.resolve();
        });
        return deferred.promise;
      },
      get: function(key) {
        var deferred;
        deferred = $q.defer();
        chrome.storage.local.get(key, function(data) {
          if (data[key]) {
            return deferred.resolve(JSON.parse(data[key]));
          }
        });
        return deferred.promise;
      },
      clear: function(key) {
        var deferred;
        deferred = $q.defer();
        chrome.storage.local.remove(key, function() {
          return deferred.resolve();
        });
        return deferred.promise;
      },
      add: function(key, item) {
        var deferred;
        deferred = $q.defer();
        this.get(key).then((function(_this) {
          return function(data) {
            data.push(item);
            return _this.set(key, data).then(function() {
              return deferred.resolve();
            });
          };
        })(this));
        return deferred.promise;
      },
      remove: function(key, index) {
        var deferred;
        deferred = $q.defer();
        this.get(key).then((function(_this) {
          return function(data) {
            data.splice(index, 1);
            return _this.set(key, data).then(function() {
              return deferred.resolve();
            });
          };
        })(this));
        return deferred.promise;
      }
    };
    return service;
  }
]);

app.service("Topbar", [
  function() {
    return {
      back: null,
      title: null,
      subtitles: [],
      reset: function() {
        this.back = null;
        this.title = null;
        return this.subtitles = [];
      },
      linkBackTo: function(url) {
        return this.back = url;
      },
      setTitle: function(t) {
        return this.title = t;
      },
      addSubtitle: function(t) {
        return this.subtitles.push(t);
      }
    };
  }
]);

app.service("GoogleSearchService", [
  "GoogleQueryFactory", function(GoogleQueryFactory) {
    var service;
    service = {
      search: function(model) {
        return chrome.windows.create({
          url: new GoogleQueryFactory(model).buildUrl(),
          incognito: model.incognito
        });
      }
    };
    return service;
  }
]);

app.service("GoogleSearchModelService", [
  "GoogleSearchModelFactory", "ChromeStorage", function(GoogleSearchModelFactory, ChromeStorage) {
    var service;
    service = {
      model: GoogleSearchModelFactory,
      addToList: function(type, item) {
        return this.model[type].push(item);
      },
      clearList: function(type) {
        return this.model[type] = [];
      },
      loadFromChrome: function(key) {
        if (key == null) {
          key = null;
        }
        if (key) {
          return this.loadKeyFromChrome(key);
        } else {
          this.loadKeyFromChrome("blacklist");
          this.loadKeyFromChrome("queryTypes");
          return this.loadKeyFromChrome("savedQueries");
        }
      },
      loadKeyFromChrome: function(key) {
        return ChromeStorage.get(key).then((function(_this) {
          return function(data) {
            var i, item, len, results;
            results = [];
            for (i = 0, len = data.length; i < len; i++) {
              item = data[i];
              results.push(_this.addToList(key, item));
            }
            return results;
          };
        })(this));
      }
    };
    return service;
  }
]);
