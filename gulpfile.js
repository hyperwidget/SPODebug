var gulp = require('gulp'),
concat = require('gulp-concat'),
nodemon = require('gulp-nodemon'),
watch = require('gulp-watch');

gulp.task('concat', function() {
    gulp.src(['./bower_components/jquery/dist/jquery.min.js',
        './bower_components/jquery-ui/jquery-ui.min.js',
        './bower_components/jquery-mobile-bower/js/*.min.js',
        './bower_components/foundation/js/foundation/*.min.js'])
        .pipe(concat('assets.js'))
        .pipe(gulp.dest('./public/javascripts/'));

    gulp.src(['./bower_components/animate-css/animate.min.css',
        './bower_components/jquery-mobile-bower/css/jquery.mobile-1.4.2.min.css',
	    './bower_components/foundation/css/foundation.css',
        './public/stylesheets/SMTT.css'])
        .pipe(concat('SMTT.css'))
        .pipe(gulp.dest('./public/stylesheets/concat'));
});

gulp.task('watch', function(){
    watch('./public/stylesheets/SMTT.css', function(){
        gulp.run('concat');
    });
});

gulp.task('server', function () {
    nodemon({ script: 'app.js', ext: 'html js', ignore: ['ignored.js'] })
        .on('restart', function () {
            console.log('restarted!')
        })
})

gulp.task('default', ['concat', 'watch', 'server']);