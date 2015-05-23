var app = angular.module("opendirectories", ["ngAria", "ngAnimate", "ngMaterial", "ngMdIcons"]);
var blacklist = ["watchtheshows.com", "mmnt.net", "listen77.com", "unknownsecret.info", "trimediacentral.com", "wallywashis.name", "ch0c.com"];
var query_types = [{name: "Movies", exts: "avi,mp4,divx"}, {name: "Music", exts: "mp3,flac,aac"}, {name: "Books", exts: "pdf,epub,mob"}, {name: "General", exts: ""}];

app.controller("appController", ["$scope", "$mdMedia", "$mdSidenav", function($scope, $mdMedia, $mdSidenav){
  $scope.query = null;
  $scope.query_types = query_types;
  $scope.query_type = 0;
  $scope.alternative = false
  $scope.quoted = true
  $scope.incognito = true;

  chrome.storage.sync.get('blacklist', function (data) {
    if(data.blacklist) {      
      blacklist = JSON.parse(data.blacklist);
      $scope.blacklist = blacklist;
    }
  });  
  chrome.storage.sync.get("query_types", function (data) {
    if(data.query_types) {      
      query_types = JSON.parse(data.query_types);
      $scope.query_types = query_types;
    }
  });  
  
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

    return query_string + build_ext(); 
  }
  var build_ext = function() {
    var query_type = query_types[$scope.query_type];
    if(query_type.exts == "") { return ""; }
    else { return " (" + query_type.exts.split(',').join("|") + ") "; }
  }

  $scope.search = function() {
    if($scope.query) { 
      chrome.windows.create({
        url: build_url(),
        incognito: $scope.incognito
      });
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
  $scope.close = function() {
     $mdSidenav('right').close();
  }
  $scope.blacklist = false;
  $scope.query_types = false;
  $scope.show_blacklist = function() { $scope.blacklist = true; }
  $scope.show_query_types = function() { $scope.query_types = true; }
  $scope.show_links = function() { $scope.blacklist = false; $scope.query_types = false; }
}]);  


var store = function(key, list) {
  var data = {};
  data[key] = JSON.stringify(list);
  chrome.storage.sync.set(data);
}  
var remove_from_list = function(key, list, item) {
  list.splice(list.indexOf(item), 1);
  store(key, list);
}

app.controller("blacklistController", ["$scope", function($scope){  
  $scope.blacklist = blacklist;
  $scope.url = null;
  $scope.add = function() {
    if($scope.url) {
      blacklist.push($scope.url);
      $scope.url = null;
      store("blacklist", blacklist);
    }
  }
  $scope.remove = function(item) {
    remove_from_list("blacklist", blacklist, item);
  }  
}]);

app.controller("queryTypesController", ["$scope", function($scope){  
  $scope.query_types = query_types;
  $scope.name = null;
  $scope.exts = null;
  $scope.add = function() {
    if($scope.name && $scope.exts) {
      query_types.push({name: $scope.name, exts: $scope.exts});
      $scope.name = null;
      $scope.exts = null;
      store("query_types", query_types);
    }
  }
  $scope.remove = function(item) {
    remove_from_list("query_types", query_types, item);
  }  
}]);