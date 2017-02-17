var gulp    = require('gulp');
var coffee  = require("gulp-coffee");
var gutil   = require("gulp-util");
var del     = require("del");

var paths = {
  source: ["app/assets/javascripts/source/**/*.coffee"],
  build: "app/assets/javascripts/build"
};

gulp.task("clean", function() {
  del([paths.build]);
});

gulp.task("default", function () {
   gulp.src(paths.source)
    .pipe(coffee({bare: true}).on("error", gutil.log))
    .pipe(gulp.dest(paths.build));
});