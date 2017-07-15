var app;

app = angular.module("downloader.auth.controllers", []);

app.controller("SessionsController", [
  "$scope", "$auth", "$mdDialog", function($scope, $auth, $mdDialog) {
    $scope.model = {
      email: "",
      password: ""
    };
    return $scope.logIn = function() {
      $scope.error = "";
      return $auth.submitLogin($scope.model).then(function(d) {
        return $mdDialog.hide();
      })["catch"](function(d) {
        $scope.error = d.errors.join(", ");
        return $(".authenticate #email").focus();
      });
    };
  }
]);

app.controller("AuthController", [
  "$scope", "$rootScope", "$mdDialog", "$auth", "$timeout", function($scope, $rootScope, $mdDialog, $auth, $timeout) {
    var setUser;
    $scope.user = null;
    setUser = function(user) {
      var initials, split;
      $scope.user = user;
      initials = (function() {
        var i, len, ref, results;
        ref = $scope.user.email.split(/@/);
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          split = ref[i];
          results.push(split[0].toUpperCase());
        }
        return results;
      })();
      return $scope.user.initials = initials.slice(0, 2).join("");
    };
    $auth.validateUser().then(function(data) {
      setUser(data);
      return $rootScope.$broadcast("downloads.get");
    }, function() {
      $mdDialog.show({
        templateUrl: "sessions/new.html",
        controller: "SessionsController",
        clickOutsideToClose: false
      });
      return $timeout((function() {
        return $(".authenticate #email").focus();
      }), 500);
    });
    $scope.logOut = function() {
      return $auth.signOut().then(function() {
        $mdDialog.show({
          templateUrl: "sessions/new.html",
          controller: "SessionsController",
          clickOutsideToClose: false
        });
        return $timeout((function() {
          return $(".authenticate #email").focus();
        }), 500);
      });
    };
    $rootScope.$on("auth:login-success", function(ev, user) {
      setUser(user);
      return $rootScope.$broadcast("downloads.get");
    });
    return $rootScope.$on("auth:logout-success", function(ev) {
      $scope.user = null;
      return $scope.downloads = [];
    });
  }
]);
