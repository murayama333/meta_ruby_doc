
# Quote from Programming Ruby 1.9

## self

[Programming Ruby 1.9](https://pragprog.com/book/ruby3/programming-ruby-1-9)Chapter 24 Metaprogrammingからの引用

```
Rubyにはカレントオブジェクトというコンセプトがある。このカレントオブジェクトには、リードオンリーなビルトイン変数selfを通じてアクセスできる。Rubyプログラミングの実行時において、selfには2つの重要な役割がある。

1つ目の役割は、selfはRubyのインスタンス変数を管理するということ。あなたがインスタンスへんすうにアクセスを試みたとき、Rubyはselfによって参照するオブジェクトを解決している。

2つ目の役割はメソッド呼び出しである。

Second, self plays a vital role in method calling. In Ruby, each method call is made on some object. There's no explicit receiver. In this case, Ruby uses the current object, self, as the receiver. It goes to self's class and looks up the method. Calling a method with an explicit receiver changes self. self is also changed by a class definition.

```