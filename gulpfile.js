var gulp = require('gulp');
var Dgeni = require('dgeni');

gulp.task('dgeni', function() {
  try {
    var dgeni = new Dgeni([require('./docs/dgeni.conf')]);
    return dgeni.generate();
  } catch(x) {
    console.log(x.stack);
    //throw x;
  }
});

process.on('uncaughtException', function(err) {
  console.log('Caught exception: ' + err);
});
