options = [
  {id: "Downloader", contexts: ["link"], title: "Add to queue"},
  {id: "DownloaderFront", contexts: ["link"], title: "Add to front of queue"}
]
for option in options
  chrome.contextMenus.remove option.id
  chrome.contextMenus.create option

chrome.contextMenus.onClicked.addListener (info, tab) ->
  if tab  
    if info.menuItemId == "Downloader"
      angular.element("body").scope().Server.service.create({url: info.linkUrl})
      alert "Added to queue"
    else if info.menuItemId == "DownloaderFront"
      angular.element("body").scope().Server.service.createInFront({url: info.linkUrl})
      alert "Added to front of queue"