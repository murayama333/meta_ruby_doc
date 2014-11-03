# 参照元

[Metaprogramming in Ruby](http://ruby-metaprogramming.rubylearning.com/html/self.html)

# Quote from Programming Ruby 1.9

## self

[Programming Ruby 1.9](https://pragprog.com/book/ruby3/programming-ruby-1-9)Chapter 24 Metaprogrammingからの引用

```
Rubyにはカレントオブジェクトというコンセプトがある。このカレントオブジェクトには、リードオンリーなビルトイン変数selfを通じてアクセスできる。Rubyプログラミングの実行時において、selfには2つの重要な役割がある。

1つ目の役割は、selfはRubyのインスタンス変数を管理するということ。あなたがインスタンスへんすうにアクセスを試みたとき、Rubyはselfによって参照するオブジェクトを解決している。

2つ目の役割はメソッド呼び出しである。Rubyでは、メソッドはオブジェクト上に定義される。明示的にレシーバを指定しないメソッド呼び出しでは、Rubyはレシーバとしてカレントオブジェクトであるselfを使う。このとき、selfの所属するクラス上でメソッドを検索する。レシーバを明示してメソッドを呼び出すとselfが変化する。このときクラス定義もまた変化する。
```
