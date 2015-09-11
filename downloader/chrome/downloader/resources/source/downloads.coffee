app = angular.module "downloader.downloads", []

app.controller "NewDownloadController", ["$scope", "$rootScope", "$mdDialog", "$http", "Server",
($scope, $rootScope, $mdDialog, $http, Server) ->
  $scope.model = {url: "", http_username: "", http_password: "", file_filter: ""}
  $scope.forms = {}
  $scope.error = null
  $scope.save = () ->
    success = ->
      $rootScope.$broadcast("downloads.get")
      $mdDialog.hide()
    failure = (message) ->
      $scope.error = message
    Server.service.create($scope.model).then success, failure
  $scope.close = -> $mdDialog.hide()
]