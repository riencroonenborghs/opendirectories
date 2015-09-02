app = angular.module "downloader.downloads", []

app.controller "NewDownloadController", ["$scope", "$rootScope", "$mdDialog", "$http", "Server",
($scope, $rootScope, $mdDialog, $http, Server) ->
  $scope.model = {url: "", http_username: "", http_password: ""}
  $scope.forms = {}
  $scope.error = null
  $scope.save = () ->
    data = {download: $scope.model}
    $http
      method: "POST"
      url: Server.service.build("/api/v1/downloads.json")
      data: data
    .then () ->
      $rootScope.$broadcast("downloads.get")
      $mdDialog.hide()
      return
    , (message) ->      
      $scope.error = message.data.error
      return
  $scope.close = -> $mdDialog.hide()
]
