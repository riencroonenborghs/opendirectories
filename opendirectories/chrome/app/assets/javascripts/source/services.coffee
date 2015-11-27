app = angular.module "opendirectories.services", []

app.service "ListService", [->
  service:
    addToList: (key, item) ->
      chrome.storage.local.get key, (data) ->
        list = []
        if data[key]
          list = JSON.parse data[key]
        list.push item
        newData = {}
        newData[key] = JSON.stringify list
        chrome.storage.local.set newData
        return
    removeAndStore: (list, key, index) ->
      list.splice index, 1
      newData = {}
      newData[key] = JSON.stringify list
      chrome.storage.local.set newData
      return
    update: (list, key, item, index) ->
      list[index] = item
      newData = {}
      newData[key] = JSON.stringify list
      chrome.storage.local.set newData
]

app.service "Topbar", [ ->
  back:     null
  title:    null
  subtitles: []
  reset: ->
    @back = null
    @title = null
    @subtitles = []
  linkBackTo: (url) -> @back = url
  setTitle: (t) -> @title = t
  addSubtitle: (t) -> @subtitles.push t
]