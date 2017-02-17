var app;

app = angular.module("downloader.downloads.controllers", []);

app.controller("NewDownloadController", [
  "$scope", "$rootScope", "$mdDialog", "$http", "Server", function($scope, $rootScope, $mdDialog, $http, Server) {
    $scope.model = {
      url: "",
      http_username: "",
      http_password: "",
      file_filter: ""
    };
    $scope.forms = {};
    $scope.error = null;
    $scope.save = function() {
      var failure, success;
      success = function() {
        $rootScope.$broadcast("downloads.get");
        return $mdDialog.hide();
      };
      failure = function(message) {
        return $scope.error = message;
      };
      return Server.service.create($scope.model).then(success, failure);
    };
    return $scope.close = function() {
      return $mdDialog.hide();
    };
  }
]);

app.controller("DownloadsController", [
  "$scope", "$rootScope", "$mdDialog", "Server", "$mdToast", function($scope, $rootScope, $mdDialog, Server, $mdToast) {
    var showToast;
    showToast = function(message) {
      return $mdToast.show($mdToast.simple().textContent(message).hideDelay(3000));
    };
    $scope.downloads = [];
    $rootScope.$on("downloads.get", function() {
      return $scope.getDownloads();
    });
    $scope.getDownloads = function() {
      return Server.service.get("/api/v1/downloads.json").then(function(data) {
        return $scope.downloads = data;
      });
    };
    $scope.newDownload = function($event) {
      return $mdDialog.show({
        templateUrl: "downloads/new.html",
        controller: "NewDownloadController",
        clickOutsideToClose: false
      }).then(function() {
        showToast("Download added.");
        return $scope.getDownloads();
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
      var download, i, index, len, ref;
      ref = $scope.downloads.items;
      for (index = i = 0, len = ref.length; i < len; index = ++i) {
        download = ref[index];
        download.weight = index;
      }
      return Server.service.reorder($scope.downloads.items).then(function() {
        showToast("Queues updated.");
        return $scope.getDownloads();
      });
    };
  }
]);
