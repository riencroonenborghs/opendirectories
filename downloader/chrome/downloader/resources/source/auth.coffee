app = angular.module "downloader.auth", []

app.controller "authController", ["$scope", "$rootScope", "Server", "$auth", "$mdDialog",
($scope, $rootScope, Server, $auth, $mdDialog) ->
  $scope.model = {email: "", password: ""}
  $scope.logIn = ->
    $scope.error = ""
    $auth.submitLogin($scope.model).then (d) -> 
      $mdDialog.hide()
    .catch (d) -> $scope.error = d.errors.join(", ")
]