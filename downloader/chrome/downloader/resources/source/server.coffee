app = angular.module "downloader.server", []

app.constant "SERVER", "localhost"
app.constant "PORT", 3000
app.factory "Server", [ "SERVER", "PORT", "ICONS", "$http", "$q", (SERVER, PORT, ICONS, $http, $q) ->
  service:
    toString: -> "http://#{SERVER}:#{PORT}"
    build: (path) -> "http://#{SERVER}:#{PORT}#{path}"
    # CRUD for downloads
    get: (path) ->
      deferred = $q.defer()
      $http
        method: "GET"
        url: @build("/api/v1/downloads.json")
        dataType: "jsonp"
      .success (data) -> 
        data.items = for item in data.items
          item = JSON.parse(item)
          item.visible = false
          item.icon = ICONS[item.status]
          item.hasPointer = (item.status != "initial" && item.status != "queued")
          item.canDelete = (item.status != "started" && item.status != "queued")
          item.canCancel = (item.status == "queued")
          item.canQueue = (item.status == "initial" || item.status == "finished" || item.status == "error" || item.status == "cancelled")
          item
        deferred.resolve data
      deferred.promise
    create: (model) ->
      deferred = $q.defer()
      data = {download: model}
      $http
        method: "POST"
        url: @build("/api/v1/downloads.json")
        data: data
      .then () ->
        deferred.resolve()
        return
      , (message) ->      
        deferred.reject(message.data.error)
        return
      deferred.promise
    delete: (download) ->
      return unless download.canDelete
      deferred = $q.defer()
      $http
        method: "DELETE"
        url: @build("/api/v1/downloads/#{download.id}")
        dataType: "jsonp"
      .success () -> deferred.resolve()
      deferred.promise
    cancel: (download) ->
      return unless download.canCancel
      deferred = $q.defer()
      $http
        method: "PUT"
        url: @build("/api/v1/downloads/#{download.id}/cancel")
        dataType: "jsonp"
      .success () -> deferred.resolve()
      deferred.promise
    queue: (download) ->
      return unless download.canQueue
      deferred = $q.defer()
      $http
        method: "PUT"
        url: @build("/api/v1/downloads/#{download.id}/queue")
        dataType: "jsonp"
      .success () -> deferred.resolve()
      deferred.promise
    clear: ->
      deferred = $q.defer()
      $http
        method: "POST"
        url: @build("/api/v1/downloads/clear")
        dataType: "jsonp"
      .success () -> deferred.resolve()
      deferred.promise     
]