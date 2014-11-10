---
title: JSアプリをCoffeeでTDDするイマドキの環境
---

## Markdownでプレゼンテーション！

[![Build Status](https://travis-ci.org/weed/FizzBuzzCoffee_p140821.svg?branch=master)](https://travis-ci.org/weed/FizzBuzzCoffee_p140821)

---

元々のタイトル

## JSアプリケーションを

## CoffeeScriptでテスト駆動開発する

## イマドキの環境を整える

・・・興味ございますか？

---

## 自己紹介

![Weed](image/weed.jpg)　植田達郎（@weed_7777）

- フリーランス
    - JavaScript
    - Objective-C
- 趣味
    - 自転車
    - 城巡り

---

## Keywords

- npm
- Gulp
- Mocha + expectJS

---

## NPM

![npm](image/npm.png)

Node版のbundler。ローカルにインストールするのがデフォルトです。

### プロジェクトの初期化

```
$ npm init
```

### モジュールをインストール

```
$ npm install &lt; package-name &gt; --save-dev
```

### コマンドを実行

```
$ npm run &lt; command &gt;
```

---

## Nodeプロジェクトの初期化

まずは以下のように打ちます。すると、対話形式でプロジェクトの情報を入力していくことができます。

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

`--save-dev` オプション

インストールしたモジュールの情報を自動で **package.json** の `devDependencies` に書いてくれるオプションです。

Development環境ではインストールされますが、Production環境ではインストールされません。

また、 `-g` オプションを付けていないので、モジュールはプロジェクトの **node_modules/** フォルダに保存され、プロジェクトの外側には何も残しません。

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

## Gulp

![gulp](image/gulp.png)

- JavaScriptのMinifyやCSSプリプロセッサのコンパイルなどを行うことができるビルドツール

---

## Gruntと何が違うのか

![grunt](image/grunt.png)

### 1. Easy to use

- コードでビルドタスクを実装するため、シンプルにタスクを定義することができます

### 2. Efficient

- node.jsのstream機能を用いているため、処理の中間ファイルなどを作ることなく、高速にビルドを行うことができます

---

### 3. High Quality

- gulpのプラグインは厳しいガイドラインに従って作成されなければいけません
- それに違反すればブラックリストに登録される可能性があります
- そのため、プラグインの品質は高く保たれます

### 4. Easy to Learn

- gulpのAPIの数は最小に保たれています
- そのため覚えることはかなり少なく、簡単に使い始めることができます

---

## coffeeをjsに変換するgulpfileを書く

**gulpfile.js**

```
require('coffee-script/register');
require('./gulpfile.coffee');
```

---

以下のように`coffee()`コマンドを通すとjsに変換されます

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

これで、以下のコマンドでcoffeeファイルをjsファイルに変換します：

```
$ ./node_modules/.bin/gulp js
```

---

## コマンドの登録（npm）

コマンドが長いので登録しましょう

**package.json**

```
  ...
  "scripts": {
    "js": "gulp js" ← 追加する
  },
  ...
```

以下のように `npm run &lt; command &gt;` コマンドを打てば、ローカルのコマンドを実行できます。Bundlerの`bundle exec`みたいな感じです。よって、グローバルには何も入れなくてよいです。

```
$ npm run js
```

これで、coffeeファイルがjsファイルに変換されます

---

## coffeeファイルの更新を監視する

coffeeファイルが更新されたら自動的にjsファイルに変換するようにしましょう。

`gulp.watch`を使います：

**gulpfile.coffee** に追記します

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

**package.json** に追記します

```
  ...
  "scripts": {
    "js": "gulp js",
    "watch": "gulp watch" ← 追加する
  },
  ...
```

これで、以下のコマンドを打つと・・・

```
$ npm run watch
```

coffeeファイルの更新を監視し始めます。

---

## ファイルが更新されたらテストを走らせる

テストファイルを`mocha()`に流し込みます：

**gulpfile.coffee** に追記します

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

**gulpfile.coffee** に追記します

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

coffeeファイルを監視し、更新があればJS変換とテストが自動的に行われます。

---

# 準備完了

あとは `app/*.coffee` と `test/*.test.coffee` を書いていきます

---

## Mocha

![Mocha](image/mocha.png)

- javascriptの単体テストで使用されるテストフレームワーク
- node.jsやブラウザから実行することや、非同期のテストも可能
- なお、mocha自体はアサーション機能は持っていません
- なので、値の検証は標準のassertとかchaiとかshouldとかexpectを使用します
- TDDやBDDスタイルでテストを記述でき、テスト結果もいろいろな形式で出力できます。
- ・・・というように汎用性が高いので、毎年トレンドが変わっていたJSテストフレームワークもようやく安定か？

---

## expectJS

![expectJS](image/LearnBoost.png)（作者のLearnBoostさんのアイコン）

- **should.js** をべースに開発されたミニマムなBDDアサーションライブラリ
- **mongoose** や **stylus** の作者が作成
- クロスブラウザ: IE6+, Firefox, Safari, Chrome, Operaで動作
- 全てのテスティングフレームワークと併用可能
- Node.JSで使用可能(`require('expect.js')`)
- スタンドアローン

---

## テストを書く

```
expect = require 'expect.js'
fizzbuzz = require '../app/FizzBuzz.js'

describe 'fizzbuzz', ->

    f = new fizzbuzz.FizzBuzz

    it 'return string Fizz when 3 is given', ->
        result = f.returnString( 3 )
        expect( result ).to.be( 'Fizz' )

```

---

## コードを書く

```
root = exports ? this
class root.FizzBuzz
  returnString: (n) ->
    "Fizz" # ひどいｗ
```

---

# あとは開発

---

## などと書きましたが・・・

---

## WebStormすげえ便利

- Coffee変換ラクチン！
- Angular入力補完バリバリ！
- Mochaテストもできる！

---

## Yeomanすげえ便利

```
$ yo angular-fullstack
```

とかやると全部やってくれる

watch、LiveReload、jslint、uglifyとか

え？Coffee？

```
$ yo angular-fullstack --coffee
```

---

## もうGruntfileやgulpfile書いている時代は終わった？

## 自分で書くのがバカバカしくなる

---

# Markdown

## でプレゼンテーション！

---

## このプレゼンテーションはMarkdownで書いてます

例えば↓が・・・

```
# おまけ

おまけです

---

## このプレゼンテーションはMarkdownで書いてます

- 説明
  + 説明
  + 説明
```

---

# おまけ

おまけです

---

## このプレゼンテーションはMarkdownで書いてます

- 説明
  + 説明
  + 説明

---

例えば↓が・・・

```
## expectJS

![expectJS](image/LearnBoost.png)（作者のLearnBoostさんのアイコン）

- **should.js** をべースに開発されたミニマムなBDDアサーションライブラリ
- **mongoose** や **stylus** の作者が作成
- クロスブラウザ: IE6+, Firefox, Safari, Chrome, Operaで動作
- 全てのテスティングフレームワークと併用可能
- Node.JSで使用可能(`require('expect.js')`)
- スタンドアローン
```

---

## expectJS

![expectJS](image/LearnBoost.png)（作者のLearnBoostさんのアイコン）

- **should.js** をべースに開発されたミニマムなBDDアサーションライブラリ
- **mongoose** や **stylus** の作者が作成
- クロスブラウザ: IE6+, Firefox, Safari, Chrome, Operaで動作
- 全てのテスティングフレームワークと併用可能
- Node.JSで使用可能(`require('expect.js')`)
- スタンドアローン

---

## mdpress

![mdpress](image/mdpress.png)（作者のAditya Bhargavaさん・・・読めない汗）

- MarkDown文書からプレゼンテーションを生成するgem

```
$ mdpress readme.md
```

- これだけで **readme** というフォルダが作成され、その中の **index.html** を開くとプレゼンテーションが始まります

---

DEMO: このプレゼンテーションのソース（Sublime）

---

## mdpressの良いところ

- Markdownラクチン！
- とりあえずLT用に見出しだけ作って、
- LT後に加筆すれば記事になります
- できた記事をQiita・はてなブログに貼り付ければパブリッシュ完了
- 無駄がないワークフロー

---

##シンタックスハイライト：Ruby

```
configure :production do
  set :cache, Dalli::Client.new(
    ENV['MEMCACHE_SERVERS'],
    :username => ENV['MEMCACHE_USERNAME'],
    :password => ENV['MEMCACHE_PASSWORD'],
    :expires_in => 60 * 30
  )
end
```

---

## シンタックスハイライト：Objective-C

```Objective-C
NSBundle* bundle = [NSBundle mainBundle];
NSString* path = [bundle pathForResource:@"Questions" ofType:@"plist"];
questions = [NSArray arrayWithContentsOfFile:path];
QuestionsMax = questions.count;

for(NSDictionary* question in questions) {
    NSLog(@"question:%@", [question objectForKey:@"Question"]);
    NSLog(@"answer:%@", [question objectForKey:@"CorrectAnswer"]);
    NSLog(@"incorrect answer:%@", [question objectForKey:@"IncorrectAnswer"]);
    NSLog(@"backgroundImage:%@", [question objectForKey:@"backgroundImage"]);
}
```

---

- 言語別のシンタックスハイライトには未対応

- しかたないので[Online syntax highlighter like TextMate](http://markup.su/highlighter/)でシンタックスハイライトします

---

## シンタックスハイライト：Objective-C

<pre style="background:#fff;color:#3b3b3b"><span style="color:#a535ae">NSBundle</span>* bundle = [<span style="color:#a535ae">NSBundle</span> <span style="color:#45ae34;font-weight:700">mainBundle</span>];
<span style="color:#a535ae">NSString</span>* path = [bundle <span style="color:#45ae34;font-weight:700">pathForResource:</span>@"Questions" <span style="color:#45ae34;font-weight:700">ofType:</span>@"plist"];
questions = [<span style="color:#a535ae">NSArray</span> <span style="color:#45ae34;font-weight:700">arrayWithContentsOfFile:</span>path];
QuestionsMax = questions.count;

<span style="color:#069;font-weight:700">for</span>(<span style="color:#a535ae">NSDictionary</span>* question in questions) {
    NSLog(@"question:%@", [question objectForKey:@"Question"]);
    NSLog(@"answer:%@", [question objectForKey:@"CorrectAnswer"]);
    NSLog(@"incorrect answer:%@", [question objectForKey:@"IncorrectAnswer"]);
    NSLog(@"backgroundImage:%@", [question objectForKey:@"backgroundImage"]);
}
</pre>

---

しかし・・・

Markdown文書を編集

→mdpressコマンドを実行

→ブラウザに移る

→ブラウザを更新

→Markdown文書の編集に戻る

---

# めんどくさい

---

## generator-mdpress

![Brian Holt](image/BrianHolt.png)（作者のBrian Holtさん）

- mdpressの作業を自動化します

```
$ yo mdpress
```

- これで自動化準備完了

---

```
$ grunt server
```

これで

- プレゼンテーションをブラウザで開き
- mdpressのソースファイルを監視し
- 更新があるとプレゼンテーションを更新し
- ブラウザの更新（LiveReload）までしてくれます

つまり**全自動**

2画面あると、片方で編集、もう片方で仕上がりのチェックができます

---

では作ったプレゼンテーションをどこに置くか？

---

## GitHub Pagesでプレゼンテーション

---

DEMO：このプレゼンテーションのリポジトリ

---

## つくり方

1. まず、普通にMarkdown文書を作る
2. `$ mdpress readme.md`でプレゼンテーションが *readme* フォルダに作られる
2. originブランチにpush
3. Setting -> GitHub Pagesで空のGitHub Pagesをつくる
4. gh-pagesブランチがGitHub上にできる
5. pullするとgh-pagesブランチもローカルに付いてくる
6. `$ git checkout gh-pages`
7. `$ cp -rf readme/* .`
8. `$ git push -u origin gh-pages` （最初だけ）
9. `$ git push` （2回目以降）

---

## 良いところ

- 改訂したとき、diffが見れる
- プルリクも送ることができる
- ソース(Markdown)とプレゼンテーション(HTML)を同じ一つのリポジトリで管理できる
- Qiitaやはてなブログのように、画像を一枚一枚アップしなくて良い
- LT後の質疑などの内容を、筆者だけでなく聞いた人もプルリクで追記できる

---

## 悪いところ
    
- 更新がややこしい

---

## 更新のやり方   

1. [origin] まずoriginブランチであるか確認
1. [origin] Markdownに追記
1. [origin] Markdownエディタを終了
1. [origin] git push
1. [origin] mdpressでリポジトリとは別のフォルダにプレゼン作成
1. [gh-pages] gh-pagesブランチに切り替える
1. [gh-pages] プレゼンをリポジトリにコピー
1. [gh-pages] git push
1. [origin] originブランチに戻しておく

---

スクリプト化してみる：

## push.sh

```
# レポジトリに入る
# フォルダ名は引数にしたい
cd 140127-2013-soukatsu-2014-houshin

# Markdownをpush
git add .
git commit -m "commited automatically by push.sh"
git push

# mdpressコマンドでreadmeフォルダを生成
cd ..
mdpress 140127-2013-soukatsu-2014-houshin/readme.md
```

---
```
# gh-pagesブランチに切り替える
cd 140127-2013-soukatsu-2014-houshin
git checkout gh-pages

# 先ほど生成したreadmeフォルダの中身をレポジトリにコピーする
cp -rf ../readme/* .

# 自動的にcommit＋push
git add .
git commit -m "commited automatically by push.sh"
git push

# originブランチに戻す
git checkout master

# 元いたディレクトリに戻る
cd ..
```

---

# めんどくさい

---

## gulp-gh-pages

![Micheal Benedict](image/MichealBenedict.jpeg)

（作者のMicheal Benedictさん。Twitter社に勤務。）

```
$ gulp deploy
```

これで全部やってくれます

ひえー

---

## さて、プレゼンが終わって

- 作ったプレゼンをSpeakerDeckやSlideShareにアップしたい
- 今までは・・・HTMLページを一枚ずつPDFにして、
- あとでたばねて一つのPDFファイルにしていた

---

# めんどくさい

---

## deck2pdf

![CedricChampeau](image/CedricChampeau.jpeg)

（作者のCedricさん。フランスからPivotal社にリモート勤務）

```
$ deck2pdf --profile=impressjs index.html
```

これで1つのPDFファイルにしてくれます

ひえー

---

## まとめ

- mdpress
- mdpress-genarator
- gulp-gh-pages
- deck2pdf

・・・で、MarkdownでGitHubな

プレゼンテーションライフを実現しましょう

ご清聴ありがとうございました

---
