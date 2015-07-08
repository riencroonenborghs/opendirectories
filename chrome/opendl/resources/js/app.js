var app             = angular.module("opendl", ["ngAria", "ngAnimate", "ngMaterial", "ngMdIcons"]);
var status_icons    = {initial: "cloud_circle", queued: "cloud", busy: "cloud_download", done: "done", error: "error"};
var server          = "localhost";
var port            = "4000";

app.controller("appController", ["$scope", "$mdMedia", "$mdSidenav", "$http", "$mdDialog", "$timeout", function($scope, $mdMedia, $mdSidenav, $http, $mdDialog, $timeout){
  $scope.path     = "Downloads";

  $scope.status_to_icon = function(download) { return status_icons[download.status]; }
  $scope.get_downloads  = function() { 
    $http({method: 'GET', url: 'http://'+server+':'+port+'/api/v1/downloads.json', dataType: 'jsonp'})
      .success(function(data){ 
        $.map(data.items, function(e,i) { e.visible = false; });
        $scope.downloads = data; 
      }); 
  }
  $scope.format_date = function(dt) { if(dt) { return moment(dt).format("Do MMMM YYYY, h:mm:ss a"); } }
  $scope.can_delete = function(dl) { return dl.status == 'initial' || dl.status == 'queued'; }
  $scope.toggle_visible = function(dl) { if(dl.started_at) { dl.visible = !dl.visible; } }

  chrome.storage.sync.get('opendl', function (data) {
    if(data.opendl) {      
      opendl        = JSON.parse(data.opendl);
      server = opendl.server;
      port   = opendl.port;
      $scope.get_downloads(); 
    }
  });  

  $scope.show_menu = function() {
    $mdSidenav('right').toggle()
  }

  $scope.new_download = function($event) {
    $mdDialog.show({
      parent: angular.element(document.body), 
      // scope: $scope,
      targetEvent: $event,
      templateUrl: "new.html",           
      controller: "DialogController",
      clickOutsideToClose: true
    });
  }

  $scope.delete_download = function(download, $event) {
    var confirm = $mdDialog.confirm()
      .title("Delete Download")
      .content("Are you sure you want to delete '" + download.url + "'?")
      .ok('BE GONE WITH IT!')
      .cancel('No')
      .targetEvent($event);
    $mdDialog.show(confirm).then(function() { delete_download(download); }, function() { /* nothing */ });
  }

  var delete_download = function(download) {
    var data = {download: {id: download.id}};
    data["method"] = "delete";
    $http({method: 'GET', url: 'http://'+server+':'+port+'/api/v1/downloads?'+$.param(data), dataType: 'jsonp'})
      .success(function(){ $scope.get_downloads(); }); 
  }

  $scope.$watch(function() { return $mdMedia('sm'); }, function(small) {
    $scope.small = small;
  });
}]);

app.controller("DialogController", ["$scope", "$mdDialog", "$http", function($scope, $mdDialog, $http){    
  $scope.model = {url: "", http_username: "", http_password: ""}
  $scope.save = function() {
    var data = {download: $scope.model}; 
    data["method"] = "create";
    $http({method: 'GET', url: 'http://'+server+':'+port+'/api/v1/downloads?'+$.param(data)})
      .success(function() { 
        // $scope.$emit("reload");
      });
  }
  $scope.close = function() {
    $mdDialog.hide();
  }
}]);  




app.controller("menuController", ["$scope", "$mdSidenav", function($scope, $mdSidenav){  
  $scope.close = function() {
     $mdSidenav('right').close();
  }
  $scope.save = function() {
    var data = {server: $scope.$parent.server, port: $scope.$parent.port};
    store("opendl", data);
  }
}]);  


var store = function(key, list) {
  var data = {};
  data[key] = JSON.stringify(list);
  chrome.storage.sync.set(data);
}  
// var remove_from_list = function(key, list, item) {
//   list.splice(list.indexOf(item), 1);
//   store(key, list);
// }

