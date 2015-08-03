app = angular.module "opendl.auth", []

app.controller "authController", ["$scope", "Server", "$auth", "Logging", "$mdDialog",
($scope, Server, $auth, Logging, $mdDialog) ->
  $scope.model = {email: "", password: ""}
  $scope.logIn = ->
    $scope.error = ""
    $auth.submitLogin($scope.model).then (d) -> $mdDialog.hide()
      .catch (d) -> $scope.error = d.errors.join(", ")
]