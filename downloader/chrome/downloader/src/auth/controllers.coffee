app = angular.module "downloader.auth.controllers", []

app.controller "SessionsController", ["$scope", "$auth", "$mdDialog",
($scope, $auth, $mdDialog) ->
  $scope.model = {email: "", password: ""}
  $scope.logIn = ->
    $scope.error = ""
    $auth.submitLogin($scope.model).then (d) -> 
      $mdDialog.hide()
    .catch (d) -> 
      $scope.error = d.errors.join(", ")
      $(".authenticate #email").focus()
]

app.controller "AuthController", [ "$scope", "$rootScope", "$mdDialog", "$auth", "$timeout",
($scope, $rootScope, $mdDialog, $auth, $timeout) ->

  $scope.user = null
  setUser = (user) ->
    $scope.user = user
    initials = for split in $scope.user.email.split(/@/)
      split[0].toUpperCase()
    $scope.user.initials = initials.slice(0,2).join("")
    
  $auth.validateUser().then (data) ->
    setUser(data)
    $rootScope.$broadcast "downloads.get"
  , () ->
    $mdDialog.show
      templateUrl: "sessions/new.html"
      controller: "SessionsController"
      clickOutsideToClose: false
    $timeout (-> $(".authenticate #email").focus()), 500

  $scope.logOut = ->
    $auth.signOut().then ->
      $mdDialog.show
        templateUrl: "sessions/new.html"
        controller: "SessionsController"
        clickOutsideToClose: false
      $timeout (-> $(".authenticate #email").focus()), 500

  $rootScope.$on "auth:login-success", (ev, user) ->
    setUser(user)
    $rootScope.$broadcast "downloads.get"

  $rootScope.$on "auth:logout-success", (ev) ->
    $scope.user = null
    $scope.downloads = []
]