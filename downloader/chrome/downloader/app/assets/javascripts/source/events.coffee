options = 
  title: "Queue in Downloader"
  contexts: ["link"]
  id: "Downloader"
chrome.contextMenus.remove options.id
chrome.contextMenus.create options
chrome.contextMenus.onClicked.addListener (info, tab) ->
  if tab  
    alert angular
    alert angular.element("body")
    alert angular.element("body").scope()
    alert angular.element("body").scope().Server
    alert angular.element("body").scope().Server.service
    angular.element("body").scope().Server.service.create({url: info.linkUrl})
    alert "Queued #{info.linkUrl}"    