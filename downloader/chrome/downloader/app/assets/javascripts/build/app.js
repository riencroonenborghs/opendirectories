var app;

app = angular.module("downloader", ["ng-token-auth", "ngAria", "ngAnimate", "ngMaterial", "ngMdIcons", "angular-sortable-view", "downloader.constants", "downloader.controllers", "downloader.server.factories", "downloader.auth.controllers", "downloader.downloads.controllers"]);

app.config(function($authProvider, SERVER, PORT) {
  return $authProvider.configure({
    apiUrl: "http://" + SERVER + ":" + PORT
  });
});

app.config(function($mdThemingProvider) {
  return $mdThemingProvider.theme("default").primaryPalette("blue").accentPalette("light-blue");
});
