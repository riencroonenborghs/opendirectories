var app;

app = angular.module("opendirectories.directives", []);

app.directive("ngEnter", function() {
  return function(scope, element, attrs) {
    return element.bind("keydown keypress", function(event) {
      if (event.which === 13) {
        scope.$apply(function() {
          return scope.$eval(attrs.ngEnter);
        });
        return event.preventDefault();
      }
    });
  };
});
