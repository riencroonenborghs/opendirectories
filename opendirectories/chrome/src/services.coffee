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
        @set(key, data).then => 
          deferred.resolve()
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

app.service "GoogleSearchService", [ "GoogleQueryFactory", (GoogleQueryFactory) ->
  service =
    search: (model) ->
      chrome.windows.create
        url: new GoogleQueryFactory(model).buildUrl(),
        incognito: model.incognito
  service
]

app.service "GoogleSearchModelService", [ "GoogleSearchModelFactory", "ChromeStorage", (GoogleSearchModelFactory, ChromeStorage) ->
  service =
    model: GoogleSearchModelFactory
    addToList: (type, item) ->
      @model[type].push item
    clearList: (type) ->
      @model[type] = []
    # load all from chrome storage (blacklist, query types, saved queries)
    loadFromChrome: (key = null) ->
      # chrome.storage.local.clear()
      if key
        @loadKeyFromChrome key
      else
        @loadKeyFromChrome "blacklist"
        @loadKeyFromChrome "queryTypes"
        @loadKeyFromChrome "savedQueries"
    loadKeyFromChrome: (key) ->
      ChromeStorage.get(key).then (data) =>
        for item in data
          @addToList key, item
  service
]