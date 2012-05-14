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
