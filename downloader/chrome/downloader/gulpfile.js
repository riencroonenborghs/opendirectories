var gulp    = require('gulp');
var coffee  = require("gulp-coffee");
var gutil   = require("gulp-util");
var del     = require("del");

var paths = {
  js_source: "src/**/*.coffee",
  js_build: "app/assets/javascripts/app",
  js_libs_source: [
    "node_modules/jquery/dist/jquery.js",
    "node_modules/angular/angular.js",
    "node_modules/angular-cookie/angular-cookie.js",
    "node_modules/ng-token-auth/dist/ng-token-auth.js",
    "node_modules/angular-animate/angular-animate.js",
    "node_modules/angular-aria/angular-aria.js",
    "node_modules/angular-material/angular-material.js",
    "node_modules/angular-material-icons/angular-material-icons.js",
    "node_modules/angular-sortable-view/src/angular-sortable-view.js",
    "node_modules/moment/moment.js"
  ],
  js_libs_build: "app/assets/javascripts/libs",
  css_source: [
    "node_modules/angular-material/angular-material.css",
    "node_modules/angular-material-icons/angular-material-icons.css"
  ],
  css_build: "app/assets/stylesheets/libs"
};

gulp.task("clean", function() {
  del([paths.js_build]);
  del([paths.js_libs_build]);
  del([paths.css_build]);
});

gulp.task("default", function () {
  // build coffee into js
  gulp.src(paths.js_source)
    .pipe(coffee({bare: true}).on("error", gutil.log))
    .pipe(gulp.dest(paths.js_build));
  // move js libs
  gulp.src(paths.js_libs_source).pipe(gulp.dest(paths.js_libs_build));
  // move css
  gulp.src(paths.css_source).pipe(gulp.dest(paths.css_build))
});