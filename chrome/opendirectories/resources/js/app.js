var app = angular.module("opendirectories", ["ngAria", "ngAnimate", "ngMaterial", "ngMdIcons"]);
app.controller("appController", ["$scope", "$mdMedia", function($scope, $mdMedia){
  $scope.query = null;
  $scope.query_types = ["Movies", "Music", "Books"];
  $scope.query_type = $scope.query_types[0];
  $scope.alternative = false
  $scope.play_dumb = true
  
  var server = "https://www.google.co.nz/";
  var path   = "search";
  var build_url  = function() { return server + path + "?q=" + encodeURIComponent($scope.build_query()); }
  $scope.build_query = function() {
    var query_string = "";
    if($scope.alternative) { query_string = '"parent directory" ' }
    else { query_string = 'intitle:"index.of" '; }
    
    if($scope.play_dumb) { query_string += '"' + $scope.query + '"'; }
    else { query_string += $scope.query; }
    query_string += ' -html -htm -php -asp -jsp -watchtheshows.com -mmnt.net -listen77.com -unknownsecret.info -trimediacentral.com -wallywashis.name -ch0c.com';

    var types = {"Movies": " (avi|mp4|divx) ", "Music": " (mp3|flac|aac) ", "Books": " (pdf|epub|mob) "};
    return query_string + types[$scope.query_type]; 
  }

  $scope.search = function() {
    if($scope.query) {
      window.open(build_url(), "_blank");
    }          
  }

  $scope.$watch(function() { return $mdMedia('sm'); }, function(small) {
    $scope.small = small;
  });
}]);