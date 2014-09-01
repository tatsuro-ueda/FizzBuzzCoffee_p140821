## JSアプリケーションを

## CoffeeScriptでテスト駆動開発する

## イマドキの環境を整える

---

## Keywords

- Gulp
- Mocha + expectJS
- npm install --save-dev
- npm run

---

## 自己紹介

植田達郎（@weed_7777）

- フリーランス
	- JavaScript
	- Objective-C
- 趣味
	- 自転車
	- 城巡り

---

## Nodeプロジェクトの初期化

まずは以下のように打つ。すると、対話形式でプロジェクトの情報を入力していくことができる。

```
$ npm init

name: (presentation) FizzBuzzCoffee_p140821
version: (0.0.0)
entry point: (Gruntfile.js)
test command: mocha
git repository: git@github.com:weed/FizzBuzzCoffee_p140821.git
keywords:
author: Tatsuro Ueda
license: (ISC)
```

---

## 必要なモジュールをインストールする

```
$ npm install mocha --save-dev
$ npm install expect.js --save-dev
$ npm install coffee-script --save-dev
$ npm install gulp --save-dev
$ npm install gulp-coffee --save-dev
$ npm install gulp-mocha --save-dev
```

---

`--save-dev` オプション

インストールしたモジュールの情報を自動で **package.json** の `devDependencies` に書いてくれるオプション。

Development環境ではインストールされるが、Production環境ではインストールされない。

また、 `-g` オプションを付けていないので、モジュールはプロジェクトの **node_modules/** フォルダに保存され、プロジェクトの外側には何も残さない。

---

## coffeeをjsに変換するgulpfileを書く

**gulpfile.js**

```
require('coffee-script/register');
require('./gulpfile.coffee');
```

---
**gulpfile.coffee**

```
gulp = require('gulp')
coffee = require('gulp-coffee')

# coffeeをjsに変換する
gulp.task 'js', ->
  gulp.src('app/*.coffee')
      .pipe(coffee())
      .pipe gulp.dest('app/')
  gulp.src('test/*.coffee')
      .pipe(coffee())
      .pipe gulp.dest('test/')
```

---

## npmコマンドから実行できるようにする

**package.json**

```
  ...
  "scripts": {
    "test": "mocha",
    "js": "gulp js" ← 追加する
  },
  ...
```

あとは、以下のように `npm` コマンドを打てば、プロジェクト（ローカル）に保存された `gulp js` コマンドを実行できる

```
$ npm run js
```

coffeeファイルがjsファイルに変換されていることを確認する

---

## coffeeファイルの更新を監視する

**gulpfile.coffee** に追記する

```
...
# coffeeファイルの更新を監視する
gulp.task 'watch', ->
  gulp.watch [
    'app/*.coffee'
    'test/*.coffee'
  ], -> gulp.start 'js'
```

---

**package.json** に追記する

```
  ...
  "scripts": {
    "test": "mocha",
    "js": "gulp js",
    "watch": "gulp watch" ← 追加する
  },
  ...
```

これで、以下のコマンドを打つと・・・

```
$ npm run watch
```

coffeeファイルの更新を監視し始める。

---

## ファイルが更新されたらテストを走らせる

**gulpfile.coffee** に追記する

```
...
mocha = require('gulp-mocha')
...
# mochaでテストする
gulp.task 'test', ->
  gulp.src( 'test/*.test.coffee', {read: false} )
    .pipe( mocha( {reporter: 'nyan'} ) )
...
```

---

**package.json** に追記する

```
...
  "scripts": {
    "js": "gulp js",
    "watch": "gulp watch",
    "test": "gulp test" ← 追加する
  },
...
```

これで、以下のコマンドを打つと・・・

```
$ npm run test
```

テストが走る。

---

**gulpfile.coffee** に追記する

```
# coffeeファイルの更新を監視する
gulp.task 'watch', ->
  gulp.watch [
    'app/*.coffee'
    'test/*.coffee'
  ], -> 
    gulp.start 'js'
    gulp.start 'test' ← 追加する
```

これで、以下のコマンドを打つと・・・

```
$ npm run watch
```

coffeeファイルを監視し、更新があればJS変換とテストが自動的に行われる。

---

# 準備完了

あとは `app/*.coffee` と `test/*.test.coffee` を書いていく

---

# Slide 16

---

# Slide 17

---

# Slide 18

---

# Slide 19

---

# Slide 20