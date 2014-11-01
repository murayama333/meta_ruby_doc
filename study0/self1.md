# 参照元

[Self - The current/default object](http://rubylearning.com/satishtalim/ruby_self.html)

# Rubyのselfについて知っておくべきこと


# Self - The current/default object


Rubyのプログラムは実行時にいつでもselfにアクセスできる。selfはコンテキストによって内容が変化するので、以下のルールについて知っておくといい。


## Top level context


トップレベルコンテキストとは、他のコンテキスト（たとえばクラスの定義など）に入っていない状態を指す。クラスやモジュールの外側と考えると良いかもしれない。たとえば、エディタを開いて次のプログラムを書いたとしよう。

```
x = 1  
```

この場合、トップレベルコンテキストにローカル変数xを定義したことになる。

```
def m  
end
```

トップレベルコンテキストにメソッドを定義した場合は、Objectクラスにインスタンスメソッドを定義することになる。また、トップレベルコンテキストに定義したメソッドはデフォルトでprivateになる。それから、Rubyはトップレベルコンテキストでselfにアクセスできうようになっている。

```
puts self
```

画面にはmainと表示されるだろう。selfとは自分自身を参照する特殊なキーワードだ。mainオブジェクトのクラスはObjectクラスになる。


## Self inside class and module definitions

クラスやモジュール定義の中では、selfはクラスやモジュールオブジェクト自身になる。


```
# p063xself1.rb  
class S  
  puts 'Just started class S'  
  puts self  
  module M  
    puts 'Nested module S::M'  
    puts self  
  end  
  puts 'Back in the outer level of S'  
  puts self  
end  
```

実行結果は次のようになる。

```
>ruby p063xself1.rb  
Just started class S  
S  
Nested module S::M  
S::M  
Back in the outer level of S  
S  
>Exit code: 0  
```


## Self in instance method definitions

定義されたメソッドが呼び出されるとき、selfはインスタンスメソッドにアクセス可能なオブジェクトになる。


```
# p063xself2.rb  
class S  
  def m  
    puts 'Class S method m:'  
    puts self  
  end  
end  
s = S.new  
s.m  
```

実行結果は次のようになる。

```
>ruby p063xself2.rb  
Class S method m:  
#<S:0x2835908>  
>Exit code: 0  
```

実行結果の#<S:0x2835908> はSクラスのインスタンスという意味だ。


## Self in singleton-method and class-method definitions

シングルトンメソッドとは、オンリーワンオブジェクト（only one object）などと呼ばれる特別なオブジェクトに定義されたメソッドのこと。シングルトンメソッドが実行されるとき、selfは自身に定義されたメソッドにもアクセスできる。

```
# p063xself3.rb  
obj = Object.new  
def obj.show  
  print 'I am an object: '  
  puts "here's self inside a singleton method of mine:"  
  puts self  
end  
obj.show  
print 'And inspecting obj from outside, ' 
puts "to be sure it's the same object:"  
puts obj  
```

実行結果は次のようになる。

```
>ruby p063xself3.rb  
I am an object: here's self inside a singleton method of mine: 
#<Object:0x2835688> 
And inspecting obj from outside, to be sure it's the same object:  
#<Object:0x2835688>  
>Exit code: 0  
```

クラスメソッドもクラスオブジェクトのシングルトンメソッドとして定義される。次のプログラムを見てみよう。

```
# p063xself4.rb  
class S  
  def S.x  
    puts "Class method of class S"  
    puts self  
  end  
end  
S.x  
```

実行結果は次のようになる。

```
>ruby p063xself4.rb  
Class method of class S  
S  
>Exit code: 0  
```

シングルトンメソッドの中のselfは、そのシングルトンメソッドを持つオブジェクトとなる。

