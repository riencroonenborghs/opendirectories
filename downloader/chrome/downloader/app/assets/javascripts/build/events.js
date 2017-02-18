var i, len, option, options;

options = [
  {
    id: "Downloader",
    contexts: ["link"],
    title: "Add to queue"
  }, {
    id: "DownloaderFront",
    contexts: ["link"],
    title: "Add to front of queue"
  }
];

for (i = 0, len = options.length; i < len; i++) {
  option = options[i];
  chrome.contextMenus.remove(option.id);
  chrome.contextMenus.create(option);
}

chrome.contextMenus.onClicked.addListener(function(info, tab) {
  if (tab) {
    if (info.menuItemId === "Downloader") {
      angular.element("body").scope().Server.service.create({
        url: info.linkUrl
      });
      return alert("Added to queue");
    } else if (info.menuItemId === "DownloaderFront") {
      angular.element("body").scope().Server.service.createInFront({
        url: info.linkUrl
      });
      return alert("Added to front of queue");
    }
  }
});
