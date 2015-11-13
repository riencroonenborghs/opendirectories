app = angular.module "downloader", [
  "ng-token-auth",
  "ngAria", 
  "ngAnimate", 
  "ngMaterial", 
  "ngMdIcons",
  "downloader.constants",
  "downloader.controllers",
  "downloader.server.constants",
  "downloader.server.factories",
  "downloader.auth.controllers",
  "downloader.downloads.controllers"
]

app.config ($authProvider, SERVER, PORT) ->
  $authProvider.configure
    apiUrl: "http://#{SERVER}:#{PORT}"

