app = angular.module "downloader", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "angular-sortable-view",
  "downloader.constants",
  "downloader.controllers",
  "downloader.server.factories",
  "downloader.auth.controllers",
  "downloader.downloads.controllers"
]

app.config ($authProvider, SERVER, PORT) ->
  $authProvider.configure
    apiUrl: "http://#{SERVER}:#{PORT}"

app.config ($mdThemingProvider) ->
  $mdThemingProvider.theme("default")
    .primaryPalette("blue")
    .accentPalette("light-blue")