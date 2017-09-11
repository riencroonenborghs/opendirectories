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

app.service("ListService", [
  function() {
    return {
      service: {
        addToList: function(key, item, callback) {
          if (callback == null) {
            callback = null;
          }
          return chrome.storage.local.get(key, function(data) {
            var list, newData;
            list = [];
            if (data[key]) {
              list = JSON.parse(data[key]);
            }
            list.push(item);
            newData = {};
            newData[key] = JSON.stringify(list);
            chrome.storage.local.set(newData);
            if (callback) {
              callback();
            }
          });
        },
        removeAndStore: function(list, key, index, callback) {
          var newData;
          if (callback == null) {
            callback = null;
          }
          list.splice(index, 1);
          newData = {};
          newData[key] = JSON.stringify(list);
          chrome.storage.local.set(newData, function() {
            if (callback) {
              return callback();
            }
          });
        },
        update: function(list, key, item, index) {
          var newData;
          list[index] = item;
          newData = {};
          newData[key] = JSON.stringify(list);
          return chrome.storage.local.set(newData);
        }
      }
    };
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
