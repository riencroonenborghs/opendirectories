var app;

app = angular.module("downloader.server.factories", []);

app.factory("Server", [
  "SERVER", "PORT", "ICONS", "$http", "$q", function(SERVER, PORT, ICONS, $http, $q) {
    return {
      service: {
        toString: function() {
          return "http://" + SERVER + ":" + PORT;
        },
        build: function(path) {
          return "http://" + SERVER + ":" + PORT + path;
        },
        get: function(path) {
          var deferred;
          deferred = $q.defer();
          $http({
            method: "GET",
            url: this.build("/api/v1/downloads.json"),
            dataType: "jsonp"
          }).then(function(response) {
            var data, item;
            data = (function() {
              var i, len, ref, results;
              ref = response.data;
              results = [];
              for (i = 0, len = ref.length; i < len; i++) {
                item = ref[i];
                item.visible = false;
                item.icon = ICONS[item.status];
                item.hasPointer = item.status !== "initial" && item.status !== "queued";
                item.canDelete = item.status !== "started" && item.status !== "queued";
                item.canCancel = item.status === "queued";
                item.canQueue = item.status === "initial" || item.status === "finished" || item.status === "error" || item.status === "cancelled";
                results.push(item);
              }
              return results;
            })();
            return deferred.resolve(data);
          });
          return deferred.promise;
        },
        create: function(model) {
          var data, deferred;
          deferred = $q.defer();
          data = {
            download: model
          };
          $http({
            method: "POST",
            url: this.build("/api/v1/downloads.json"),
            data: data
          }).then(function() {
            deferred.resolve();
          }, function(message) {
            deferred.reject(message.data.error);
          });
          return deferred.promise;
        },
        createInFront: function(model) {
          var data, deferred;
          deferred = $q.defer();
          data = {
            download: model,
            front: true
          };
          $http({
            method: "POST",
            url: this.build("/api/v1/downloads.json"),
            data: data
          }).then(function() {
            deferred.resolve();
          }, function(message) {
            deferred.reject(message.data.error);
          });
          return deferred.promise;
        },
        "delete": function(download) {
          var deferred;
          if (!download.canDelete) {
            return;
          }
          deferred = $q.defer();
          $http({
            method: "DELETE",
            url: this.build("/api/v1/downloads/" + download.id),
            dataType: "jsonp"
          }).then(function() {
            return deferred.resolve();
          });
          return deferred.promise;
        },
        cancel: function(download) {
          var deferred;
          if (!download.canCancel) {
            return;
          }
          deferred = $q.defer();
          $http({
            method: "PUT",
            url: this.build("/api/v1/downloads/" + download.id + "/cancel"),
            dataType: "jsonp"
          }).then(function() {
            return deferred.resolve();
          });
          return deferred.promise;
        },
        queue: function(download) {
          var deferred;
          if (!download.canQueue) {
            return;
          }
          deferred = $q.defer();
          $http({
            method: "PUT",
            url: this.build("/api/v1/downloads/" + download.id + "/queue"),
            dataType: "jsonp"
          }).then(function() {
            return deferred.resolve();
          });
          return deferred.promise;
        },
        clear: function() {
          var deferred;
          deferred = $q.defer();
          $http({
            method: "POST",
            url: this.build("/api/v1/downloads/clear"),
            dataType: "jsonp"
          }).then(function() {
            return deferred.resolve();
          });
          return deferred.promise;
        },
        reorder: function(downloads) {
          var data, deferred, download, i, len;
          deferred = $q.defer();
          data = {
            data: {}
          };
          for (i = 0, len = downloads.length; i < len; i++) {
            download = downloads[i];
            data.data[download.id] = download.weight;
          }
          $http({
            method: "POST",
            url: this.build("/api/v1/downloads/reorder"),
            data: data
          }).then(function() {
            deferred.resolve();
          }, function(message) {
            deferred.reject(message.data.error);
          });
          return deferred.promise;
        }
      }
    };
  }
]);
