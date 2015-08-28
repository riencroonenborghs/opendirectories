app = angular.module "opendl-downloader.auth", []

app.controller "authController", ["$scope", "$rootScope", "Server", "$auth", "Logging", "$mdDialog",
($scope, $rootScope, Server, $auth, Logging, $mdDialog) ->
  $scope.model = {email: "", password: ""}
  $scope.logIn = ->
    $scope.error = ""
    $auth.submitLogin($scope.model).then (d) -> 
      $mdDialog.hide()
      $rootScope.$broadcast("reload")
      $rootScope.$emit("reload")
    .catch (d) -> $scope.error = d.errors.join(", ")
]