var app;

app = angular.module("downloader.downloads.controllers", []);

app.controller("NewDownloadController", [
  "$scope", "$rootScope", "$mdDialog", "Server", function($scope, $rootScope, $mdDialog, Server) {
    $scope.model = {
      url: "",
      http_username: "",
      http_password: "",
      file_filter: "",
      audio_only: false,
      audio_format: "mp3"
    };
    $scope.forms = {};
    $scope.error = null;
    $scope.resetAndCheck = function() {
      $scope.error = null;
      return $scope.isYoutube = $scope.model.url.match(/youtu/) !== null;
    };
    $scope.audioFormats = ["best", "aac", "flac", "mp3", "m4a", "opus", "vorbis", "wav"];
    $scope.save = function() {
      var failure, success;
      success = function() {
        $rootScope.$broadcast("downloads.get");
        return $mdDialog.hide(true);
      };
      failure = function(message) {
        return $scope.error = message;
      };
      return Server.service.create($scope.model).then(success, failure);
    };
    return $scope.close = function() {
      return $mdDialog.hide(false);
    };
  }
]);

app.controller("DownloadsController", [
  "$scope", "$rootScope", "$mdDialog", "Server", "$mdToast", function($scope, $rootScope, $mdDialog, Server, $mdToast) {
    var showToast;
    $scope.statuses = ["initial", "queued", "started", "finished", "error", "cancelled"];
    $scope.tabStatuses = ["queued", "started", "finished", "error", "cancelled"];
    showToast = function(message) {
      return $mdToast.show($mdToast.simple().textContent(message).hideDelay(3000));
    };
    $scope.downloads = false;
    $rootScope.$on("downloads.get", function() {
      return $scope.getDownloads();
    });
    $scope.getDownloads = function() {
      $scope.downloads = false;
      return Server.service.get("/api/v1/downloads.json").then(function(data) {
        var download, i, len, results, status;
        $scope.downloads = {};
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          download = data[i];
          results.push((function() {
            var base, j, len1, ref, results1;
            ref = $scope.statuses;
            results1 = [];
            for (j = 0, len1 = ref.length; j < len1; j++) {
              status = ref[j];
              (base = $scope.downloads)[status] || (base[status] = []);
              if (download.status === status) {
                results1.push($scope.downloads[status].push(download));
              } else {
                results1.push(void 0);
              }
            }
            return results1;
          })());
        }
        return results;
      });
    };
    $scope.newDownload = function($event) {
      return $mdDialog.show({
        templateUrl: "downloads/new.html",
        controller: "NewDownloadController",
        clickOutsideToClose: false
      }).then(function(added) {
        if (added) {
          showToast("Download added.");
          return $scope.getDownloads();
        }
      });
    };
    $scope.deleteDownload = function(download, $event) {
      var confirm;
      confirm = $mdDialog.confirm().title("Delete Download").content("Are you sure you want to delete '" + download.url + "'?").ok("BE GONE WITH IT!").cancel("No").targetEvent($event);
      return $mdDialog.show(confirm).then((function() {
        return Server.service["delete"](download).then(function() {
          showToast("Download deleted.");
          return $scope.getDownloads();
        });
      }));
    };
    $scope.cancelDownload = function(download) {
      return Server.service.cancel(download).then(function() {
        showToast("Download cancelled.");
        return $scope.getDownloads();
      });
    };
    $scope.queueDownload = function(download) {
      return Server.service.queue(download).then(function() {
        showToast("Download queued.");
        return $scope.getDownloads();
      });
    };
    $scope.clearDownloads = function() {
      return Server.service.clear().then(function() {
        showToast("All queues cleared.");
        return $scope.getDownloads();
      });
    };
    return $scope.reorderDownloads = function() {
      var data, download, index;
      if ($scope.selectedIndex !== 0) {
        return;
      }
      data = (function() {
        var i, len, ref, results;
        ref = $scope.downloads.queued;
        results = [];
        for (index = i = 0, len = ref.length; i < len; index = ++i) {
          download = ref[index];
          download.weight = index;
          results.push(download);
        }
        return results;
      })();
      return Server.service.reorder(data).then(function() {
        showToast("Queues updated.");
        return $scope.getDownloads();
      });
    };
  }
]);
