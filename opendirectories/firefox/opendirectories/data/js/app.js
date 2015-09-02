var app = angular.module("opendirectories", ["ngAria", "ngAnimate", "ngMaterial", "ngMdIcons"]);
var blacklist = ["watchtheshows.com", "mmnt.net", "listen77.com", "unknownsecret.info", "trimediacentral.com", "wallywashis.name", "ch0c.com"];

app.controller("appController", ["$scope", "$mdMedia", "$mdSidenav", function($scope, $mdMedia, $mdSidenav){
  $scope.query = null;
  $scope.query_types = ["Movies", "Music", "Books", "General"];
  $scope.query_type = $scope.query_types[0];
  $scope.alternative = false
  $scope.quoted = true
  
  var server = "https://www.google.com/";
  var path   = "search";
  var build_url  = function() { return server + path + "?q=" + encodeURIComponent($scope.build_query()); }
  $scope.build_query = function() {
    var query_string = "";
    if($scope.alternative) { query_string = '"parent directory" ' }
    else { query_string = 'intitle:"index.of" '; }
    
    if($scope.quoted) { query_string += '"' + $scope.query + '"'; }
    else { query_string += $scope.query; }
    query_string += ' -html -htm -php -asp -jsp ';
    for(var i=0; i<blacklist.length; ++i) { query_string += " -" + blacklist[i]; }

    var types = {"Movies": " (avi|mp4|divx) ", "Music": " (mp3|flac|aac) ", "Books": " (pdf|epub|mob) ", "General": ""};
    return query_string + types[$scope.query_type]; 
  }

  $scope.search = function() {
    if($scope.query) { 
      window.open(build_url(), "_blank");
    }          
  }

  $scope.show_menu = function() {
    $mdSidenav('right').toggle()
  }

  $scope.$watch(function() { return $mdMedia('sm'); }, function(small) {
    $scope.small = small;
  });
}]);


app.controller("menuController", ["$scope", "$mdSidenav", function($scope, $mdSidenav){  
  // chrome.storage.sync.get('blacklist', function (data) {
  //   if(data.blacklist) {      
  //     blacklist = JSON.parse(data.blacklist);
  //     $scope.blacklist = blacklist;
  //   }
  // });
   
  $scope.blacklist = blacklist;
  $scope.close = function() {
     $mdSidenav('right').close();
  }

  $scope.url = null;
  $scope.add = function() {
    if($scope.url) {
      blacklist.push($scope.url);
      $scope.url = null;
      store();
    }
  }

  $scope.remove = function(item) {
    blacklist.splice(blacklist.indexOf(item), 1);
    store();
  }

  var store = function() {
    var data = {}; data['blacklist'] = JSON.stringify(blacklist);
    // chrome.storage.sync.set(data);
  }  
}]);