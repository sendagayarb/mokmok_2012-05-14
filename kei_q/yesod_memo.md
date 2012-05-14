# yesodとは

yesodはHaskellで作成されたフルスタックwebフレームワーク
以下を特長としている

- Type Safety
- Concise
- Performance

PHPやrubyとは異なり、静的型付言語で関数型言語なので、
同じことを実現するのに別の手段で用いている

# メリット

## Type Safety

- compileできたらサイト内でリンク切れ無し
- Haskellそのものの型による設計

## Concise

- scaffoldでコード自動生成
- template metaprogrammingでboilerplate(冗長なコード)を自動生成
    - routing table
    - HTML, CSS, JSも

## Performance

- GHC(Haskellのcompiler)が速いコード出力してくれる
- 多くをcompile時に処理
- HTML, CSS, JSを静的に解析する
    - disk I/Oを回避
    - renderingを最適化
- conduitやbytestringで高速化
- yesodが使用しているwarpというHaskell製web serverが高速
    - ここにgraphを載せる




# yesodの環境構築 (macのみ)

brew install haskell-platform
cabal install yesod-platform
yesod init



# [Basic](http://www.yesodweb.com/book/basics)

## Hello World

yesod initを使用しないサンプル
最小構成で17行程度のコードが示されている。
この中で使用しているHaskellの特殊な機能については [Haskell](http://www.yesodweb.com/book/haskell) で説明している

- Data Type
- Tools
- Language Pragmas
- Overloaded Strings
- Type Families
- Template Haskell
- QuasiQuotes

本文にあるコードを試したいときは、内容をmain.hsのようなファイルにコピペして以下を実行する。runhaskellはrunghcでも可。これはHaskellのコードをscriptとして実行するためのコマンドツール。
実行するとlocalhost:3000が待機状態となる。

```
$ runhaskell main.hs
Application launched, listening on port 3000
```

curlで試すと、確かに本文通りの結果が取得できる

```
$ curl http://localhost:3000
<!DOCTYPE html>
<html><head><title></title></head><body>Hello World!</body></html>%  
```

## Routing

railsみたいなfront controller partternというのをyesodも採用している。
routing tableがあって、まずここを参照してからその先の処理に向う形式らしい。
以下がhello worldのrouting部分

```
mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]
```

Haskellのコードに見えないが、これはHaskellの機能でrouting用のDSLを定義しているから。
- /
    - routingのpath
- HomeR
    - routeに割り当てられたresourceの名前
- GET
    - routeが許可するmethod
ちなみに上記のコードは'/'にGETでアクセスするとgetHomeRという関数が評価されることを表している

ちなみに`mkYesod`と`parseRoutes`はtemplate haskellの機能を使ったもの。
どのようなコードが生成されるか確認したいときはコンパイルオプションで`--ddump-splices`するとわかるみたいだけど、そのコードも本文にあるので略。

## Handler function

上記の定義によりgetHomeRが評価されるのはわかったが、またいくつか新しいのが登場する。

```
getHomeR :: Handler RepHtml
getHomeR = defaultLayout [whamlet|Hello World!|]
```

- defaultLayout
    - HTMLを出力するサイトのテンプレート
    - jsonとかは別moduleでdefaultLayoutJsonとかあったりする [yesod-json](http://hackage.haskell.org/package/yesod-json-1.0.0)
- whamlet
    - これまたtemplate haskellによるDSL
    - HTMLっぽいなにか

つまり、これらは最終的なHTMLを出力するためのなにか。
詳しくは後の shakespeare(ライブラリの名前)の章で説明。

## The Foundation

```
data HelloWorld = HelloWorld
instance Yesod HelloWorld
```

上記のような型は、このコードの土台となるdataとclassらしい。
以下のようなプログラムの初期化・使用に必要となる。
規約を決めて冗長なコードを減らしている?

- DBのconnection pool
- configFileからの設定読み込み
- HTTP connection manager

## Running

s

## Resources and type-safe URLs

hamletなどの中でリソース名をもとにURLのリンクなどを作成できる。
これらはコンパイル時に確認されるため、コンパイルが通ればリンク切れはない

## the scaffolded site

ここまでは地道に0からコードを書いてきたが、scaffoldの機能もある。
以下を実行するとそれができる。
yesod tutorialで説明されているのは以下で出力されているコード。
routing tableや各種templateなどがdirectory分けされて生成されている。
基本こっちでやるのが良いかも。

```
$ yesod init
```

## development server

yesodは使用しているファイルが更新されたら、自動的に再コンパイルして読み込む開発者用の機能がある。`yesod init`しているのなら以下のように起動すればいい。

```
$ yesod devel
```

## summary

略

# 公開されている参考資料

## http://www.yesodweb.com/book

公式のyesod book
oreillyから発売されるが、onlineで全文読める

## http://yannesposito.com/Scratch/en/blog/Yesod-tutorial-for-newbies/

初心者向けtutorial
routeを追加するところから簡単なBlogのサンプルを作成するまで

## http://mew.org/~kazu/material/2012-yesod.pdf
- 2012.3.5
- kaz yamamotoさんの資料
- yesodの概要とwarpについて

## http://melpon.org/yesodbookjp

yesod bookの翻訳。まだ記事は少ないけど期待
