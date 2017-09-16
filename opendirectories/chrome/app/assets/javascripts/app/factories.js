var app;

app = angular.module("opendirectories.factories", []);

app.factory("GoogleQueryFactory", [
  function() {
    return (function() {
      function _Class(model1) {
        this.model = model1;
        this.server = "https://www.google.com/";
        this.path = "search";
        return;
      }

      _Class.prototype.buildUrl = function() {
        return "" + this.server + this.path + "?q=" + (encodeURIComponent(this.buildQuery()));
      };

      _Class.prototype.buildQuery = function() {
        var blacklistItem, i, len, queryString, ref;
        queryString = "";
        queryString = this.model.alternative ? "\"parent directory\" " : "intitle:\"index.of\" ";
        queryString += this.model.quoted ? " \"" + this.model.query + "\" " : this.model.query;
        queryString += " -html -htm -php -asp -jsp ";
        ref = this.model.blacklist;
        for (i = 0, len = ref.length; i < len; i++) {
          blacklistItem = ref[i];
          queryString += " -" + blacklistItem;
        }
        return "" + queryString + (this.buildExt());
      };

      _Class.prototype.buildExt = function() {
        var queryType;
        queryType = this.model.queryTypes[this.model.queryType];
        if (queryType.exts === "") {
          return "";
        } else {
          return " (" + (queryType.exts.split(',').join("|")) + ") ";
        }
      };

      return _Class;

    })();
  }
]);

app.factory("GoogleSearchModelFactory", [
  "DEFAULT_SETTINGS", function(DEFAULT_SETTINGS) {
    var model;
    model = {
      query: null,
      queryTypes: $.extend([], DEFAULT_SETTINGS.QUERY_TYPES),
      queryType: 0,
      alternative: false,
      quoted: true,
      incognito: true,
      blacklist: $.extend([], DEFAULT_SETTINGS.BLACKLIST),
      savedQueries: []
    };
    return model;
  }
]);
