chrome.runtime.onInstalled.addListener (details) ->
  options = 
    title: "Queue in Downloader"
    contexts: ["link"]
    id: "Downloader"
  chrome.contextMenus.remove options.id
  chrome.contextMenus.create options
  chrome.contextMenus.onClicked.addListener (info, tab) ->
    angular.element("body").scope().Server.service.create({url: info.linkUrl})