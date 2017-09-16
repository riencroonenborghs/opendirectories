app = angular.module "opendirectories", [
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "ngRoute",
  "opendirectories.controllers",
  "opendirectories.services",
  "opendirectories.directives",
  "opendirectories.factories",
  "opendirectories.blacklist.controllers",
  "opendirectories.queryTypes.controllers"
]

app.service "DEFAULT_SETTINGS", [->
  BLACKLIST: [
    "watchtheshows.com", 
    "mmnt.net", 
    "listen77.com", 
    "unknownsecret.info", 
    "trimediacentral.com", 
    "wallywashis.name", 
    "ch0c.com", 
    "hypem.com"
  ]
  QUERY_TYPES: [
    {name: "Movies",        exts: "avi,mp4,mkv,vob,divx"}
    {name: "Music",         exts: "mp3,flac,aac"}
    {name: "Books",         exts: "pdf,epub,mob"}
    {name: "Mac Software",  exts: "dmg,sit"}
    {name: "General",       exts: ""}
  ]
]

app.config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when "/settings/blacklist",
      templateUrl: "app/views/settings/blacklist/index.html"
      controller: "BlacklistIndexController"
    .when "/settings/blacklist/new",
      templateUrl: "app/views/settings/blacklist/new.html"
      controller: "BlacklistNewController"
    .when "/settings/blacklist/:index",
      templateUrl: "app/views/settings/blacklist/edit.html"
      controller: "BlacklistEditController"
    .when "/settings/queryTypes",
      templateUrl: "app/views/settings/query_types/index.html"
      controller: "QueryTypesIndexController"
    .when "/settings/queryTypes/new",
      templateUrl: "app/views/settings/query_types/new.html"
      controller: "QueryTypeNewController"
    .when "/settings/queryTypes/:index",
      templateUrl: "app/views/settings/query_types/edit.html"
      controller: "QueryTypeEditController"
    .otherwise
      templateUrl: "app/views/index.html"
      controller: "appController"

  $locationProvider.html5Mode true  


  