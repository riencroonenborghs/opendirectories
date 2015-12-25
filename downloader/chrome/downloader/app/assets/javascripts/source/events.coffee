options = 
  title: "Queue in Downloader"
  contexts: ["link"]
  id: "Downloader"
chrome.contextMenus.remove options.id
chrome.contextMenus.create options
chrome.contextMenus.onClicked.addListener (info, tab) ->
  if tab  
    angular.element("body").scope().Server.service.create({url: info.linkUrl})
    alert "Queued #{info.linkUrl}"    