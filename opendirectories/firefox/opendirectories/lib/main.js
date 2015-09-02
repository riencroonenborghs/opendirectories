var { ToggleButton } = require('sdk/ui/button/toggle');
var self = require("sdk/self");
var panel = require("sdk/panel");

var search = panel.Panel({
  contentURL: self.data.url("search.html"),
  width: 640,
  height: 280,
  onHide: function() {
    button.state('window', {checked: false});
  }
});
search.on("show", function() {
  search.port.emit("show");
});

var button = ToggleButton({
  id: "opendirectories",
  label: "Opendirectories",
  icon: {
    "16": "./icons/icon-16.png",
    "32": "./icons/icon-32.png",
    "64": "./icons/icon-64.png"
  },
  onChange: function(state) {
    if (state.checked) {
      search.show({
        position: button
      });
    }
  }
});