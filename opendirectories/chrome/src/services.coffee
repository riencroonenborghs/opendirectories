app = angular.module "opendirectories.services", []

app.service "ChromeStorage", [ "$q", ($q) ->
  service =
    set: (key, data) ->
      _data = {}
      _data[key] = JSON.stringify data
      deferred = $q.defer()
      chrome.storage.local.set _data, -> deferred.resolve()
      deferred.promise
    get: (key) ->
      deferred = $q.defer()
      chrome.storage.local.get key, (data) ->
        deferred.resolve(JSON.parse(data[key])) if data[key]
      deferred.promise
    clear: (key) ->
      deferred = $q.defer()
      chrome.storage.local.remove key, -> deferred.resolve()
      deferred.promise
    add: (key, item) ->
      deferred = $q.defer()
      @get(key).then (data) =>
        data.push item
        @set(key, data).then => deferred.resolve()
      deferred.promise
    remove: (key, index) ->
      deferred = $q.defer()
      @get(key).then (data) =>
        data.splice(index, 1)
        @set(key, data).then => deferred.resolve()
      deferred.promise
  service
]

app.service "ListService", [->
  service:
    addToList: (key, item, callback = null) ->
      chrome.storage.local.get key, (data) ->
        list = []
        if data[key]
          list = JSON.parse data[key]
        list.push item
        newData = {}
        newData[key] = JSON.stringify list
        chrome.storage.local.set newData
        callback() if callback
        return
    removeAndStore: (list, key, index, callback = null) ->
      list.splice index, 1
      newData = {}
      newData[key] = JSON.stringify list
      chrome.storage.local.set newData, ->
        callback() if callback
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