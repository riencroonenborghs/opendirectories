options = 
  title: "Queue in Downloader"
  contexts: ["link"]
  id: "Downloader"
chrome.contextMenus.remove options.id
chrome.contextMenus.create options
chrome.contextMenus.onClicked.addListener (info, tab) ->
  if tab  
    alert "Queued #{info.linkUrl}"
    angular.element("body").scope().Server.service.create({url: info.linkUrl})