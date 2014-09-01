gulp = require('gulp')
coffee = require('gulp-coffee')
mocha = require('gulp-mocha')
deploy = require('gulp-gh-pages')

# coffeeをjsに変換する
gulp.task 'js', ->
  gulp.src( 'app/*.coffee' )
      .pipe( coffee() )
      .pipe gulp.dest( 'app/' )
  gulp.src( 'test/*.coffee' )
      .pipe( coffee() )
      .pipe gulp.dest( 'test/' )

# coffeeファイルの更新を監視する
gulp.task 'watch', ->
  gulp.watch [
    'app/*.coffee'
    'test/*.coffee'
  ], -> 
    gulp.start 'js'
    gulp.start 'test'

# mochaでテストする
gulp.task 'test', ->
  gulp.src( 'test/*.test.coffee', {read: false} )
    .pipe( mocha( {reporter: 'nyan'} ) )

# readmeフォルダをgh-pagesブランチにデプロイする
gulp.task('deploy', ->
    gulp.src("./readme/**/*")
        .pipe(deploy())
)