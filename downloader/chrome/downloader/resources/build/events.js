// Generated by CoffeeScript 1.9.3
(function() {
  chrome.runtime.onInstalled.addListener(function(details) {
    var options;
    options = {
      title: "Queue in Downloader",
      contexts: ["link"],
      id: "Downloader"
    };
    chrome.contextMenus.remove(options.id);
    chrome.contextMenus.create(options);
    return chrome.contextMenus.onClicked.addListener(function(info, tab) {
      return angular.element("body").scope().Server.service.create({
        url: info.linkUrl
      });
    });
  });

}).call(this);