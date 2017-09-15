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