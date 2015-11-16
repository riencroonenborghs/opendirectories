app = angular.module "opendirectories.services", []

app.service "ListService", [->
  service:
    store: (key, list) ->
      data = {}
      data[key] = JSON.stringify list
      chrome.storage.sync.set data    
    removeAndStore: (key, list, item) ->
      list.splice list.indexOf(item), 1
      @store key, list
]


