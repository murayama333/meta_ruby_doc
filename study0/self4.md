# 参照元

[Understanding Ruby Singleton Classes](http://www.devalot.com/articles/2008/09/ruby-singleton)


# Understanding Ruby Singleton Classes

Posted by Peter J. Jones on September 15, 2008

もしあなたがC++やJavaのような静的なオブジェクト指向言語を学んだことがあるなら、Rubyの動的な性質は魔法のようで捉えにくく感じるかもしれない。メタプログラミングのシンタックスを実行した後には、その背後で何が起きたのか理解に苦しむかもしれない。シングルトンクラス、シングルトンデザインパターンと混同されがちなこのクラスは、このような理解に苦しむ現象を簡単に引き起こす。

シングルトンクラスというこの名前は紛らわしいので、人によってはobject-specific classes、 anonymous classes、virtual classes、eigenclassesなんて呼ばれることもある。私のお気に入りはAnonymous classであるが、Rubyのインタープリタの中ではsingletonという用語が使われているので私もそれに倣うものとする。

実際のところ、シングルトンクラスを学ぶことは難しくない。以下にAccelerated Ruby workshopからの抜粋を示すが、ここではシングルトンクラスの神秘のベールを排除し、日々のRuby開発に役立ててもらえるようにするつもりだ。

## Method Dispatching

シングルトンのミステリアスな世界に飛び込むまえに、Rubyの動的ディスパッチを簡単に復習しておこう。個々のメソッド呼び出しにおいて、Rubyインタープリタは実行すべきメソッドを見つけるためにレシーバの継承関係を調べなければならない。

```
foobar = Array.new
foobar.class # => Array
foobar.size  # => 0
```

最後のステートメントでは、`foobar`オブジェクトに対してsizeメソッドを呼んでいる。`foobar`オブジェクトはsizeメソッド呼び出しの時のレシーバとも言える。インタープリタはレシーバのクラスからsizeメソッドを探索を始める。このケースではArrayクラスでsizeメソッドが見つかる。

もしArrayクラスでsizeメソッドが見つからない場合、クラスの継承関係を辿ってメソッドの探索を続ける。それでもメソッドが見つからない場合は、メソッド呼び出しをアボートして、method_missingメッセージをレシーバは返却する。幸い、Arrayクラスにはsizeメソッドが定義されていたため、戻り値として0が返却されたのである。

以下に示す図は、オブジェクトとクラスのつながりを示している。またクラスと親クラスの関係も示している。親クラスとはスーパークラスと呼ばれるものだ。

![Dynamic Dispatch Without Singletons](http://www.devalot.com/assets/articles/2008/09/ruby-singleton/normal-array.jpg)

## Enter the Singleton Class

シングルトンクラスが何であるか複雑な話題に入る前に、それが何をするのか見ておこう。

```
foobar = Array.new

def foobar.size
  "Hello World!"
end

foobar.size  # => "Hello World!"
foobar.class # => Array

bizbat = Array.new
bizbat.size  # => 0
```

前の例では、`Array`クラスの新しいインスタンスを生成し、`foobar`という変数に代入している。その後、突然ではあるが面白い形のメソッドの定義を行っている。

Rubyはフレキシブルな言語である。メソッド定義時にレシーバを指定することができる。つまり、私たちはRubyに新しいメソッドを定義するのがどのオブジェクトであるかを伝えることができる。このシンタックスに見覚えがあるかもしれない。クラスメソッドを定義するときとよく似ている。しかし、この例では`foobar`にだけメソッドを追加したのである。

つまり先のメソッド定義はクラスオブジェクトではなく、特定のオブジェクトだけに定義されたということだ。先のコードを見れば、Arrayクラスの他のオブジェクトには新しいsizeメソッドが定義されていないのに気づくだろう。これらのオブジェクトはArrayクラスのsizeメソッドを呼び出したままとなっている。

このちょっと生意気なfoobarオブジェクトは以前の状態から少し変化したのだ。何が変化したのか？foobarオブジェクトは他のオブジェクトが持っていないメソッドを持つようになったのはなぜか？「シングルトンクラス」それが答えだ。特定のオブジェクトにメソッドを追加した場合、Rubyはこれらのメソッドを保持するコンテナとして、クラスの継承関係に新たなanonymous（匿名）クラスを追加する。

![Dynamic Dispatch With Singletons](http://www.devalot.com/assets/articles/2008/09/ruby-singleton/singleton-array.jpg)

foobarの継承関係におけるこの新しいシングルトンクラスには、いくつかの特殊な性質がある。先にも述べたが、シングルトンクラスは匿名クラスだ。名前を持たないため他のクラスのように定数でアクセスすることはできない。あなたは特殊なやり方でシングルトンクラスにアクセスすることができるが、シングルトンクラスから新たなインスタンスを生成することはできない。


オブジェクトの生成は、インタープリタによって特別なシングルトンフラグを持つクラスだと判断され、防止される。この内部フラグは、オブジェクトのクラスメソッドの呼び出しにも利用されている。あなたはメソッド呼び出しからシングルトンクラスが返されることを期待するかもしれないが、実際にはインタープリタはシングルトンクラスをスキップするため、Arrayクラスが返却されることになる。

他にもシングルトンクラスの副作用として、シングルトンメソッドの中でsuper呼び出しが可能となっている。先のコードの場合、シングルトンメソッドの中でsuperを使うことができる。もちろん、この場合はArrayクラスのsizeメソッド呼び出しとなる。

副作用についてもう一つ、オブジェクトのシングルトンクラスが気になる場合は`singleton_methods`を使えばシングルトンメソッドの名前の一覧を取得できる。

最後に注意事項として、シングルトンクラスを生成したオブジェクトは`Marshal.dump`することができなくなる。マーシャルライブラリはシングルトンクラスをサポートしないからだ。

```
>> Marshal.dump(foobar)
TypeError: singleton can't be dumped
        from (irb):6:in `dump'
        from (irb):6
```

いくつかのライブラリでは内部でマーシャル呼び出しが行われている場合がある。その場合、上に示すようなエラーメッセージが表示されるだろう。



## More Ways to Skin a Singleton

It shouldn’t be surprising that Ruby has several ways to create a singleton class for an object. Below you’ll find no less than three additional techniques.

### Methods From Modules

When you use the extend method on an object to add methods to it from a module, those methods are placed into a singleton class.

```
module Foo
  def foo
    "Hello World!"
  end
end

foobar = []
foobar.extend(Foo)
foobar.singleton_methods # => ["foo"]
```

### Opening the Singleton Class Directly

Here comes the funny syntax that everyone has been waiting for. The code below tends to confuse people when they see it for the first time but it’s pretty useful and fairly straightforward.

```
foobar = []

class << foobar
  def foo
    "Hello World!"
  end
end

foobar.singleton_methods # => ["foo"]
```

Anytime you see a strange looking class definition where the class keyword is followed by two less than symbols, you can be sure that a singleton class is being opened for the object to the right of those symbols.

In this example, the singleton class for the foobar object is being opened. As you probably already know, Ruby allows you to reopen a class at any point adding methods and doing anything you could have done in the original class definition. As with the rest of the examples in this section a foo method is being added to the foobar singleton class.

### Evaluating Code in the Context of an Object

If you’ve made it this far it shouldn’t be shocking to see a singleton class created when you define a method inside an instance_eval call.

    foobar = []
    
    foobar.instance_eval <<EOT
      def foo
        "Hello World!"
      end
    EOT
      
    foobar.singleton_methods # => ["foo"]
    


## Practical Uses of Singleton Classes

Before you chalk this all up to useless black magic let’s tie everything off with some practical examples. Believe it or not, you probably create singleton classes all the time.

### Class Methods

While some object oriented languages have class structures that support both instance methods and class methods (sometimes called static methods), Ruby only supports instance methods. If Ruby only supports instances methods where do all those class methods you’ve been creating end up? Why, the singleton class of course.

This is possible because Ruby classes are actually objects instantiated from the Class class. Their names are constants that point to this object instantiated from the Class class. While this object holds the instance methods for objects instantiated from it, its so-called class methods are kept on a singleton class.

    class Foo
      
      def self.one () 1 end
      
      class << self
        def two () 2 end
      end
    
      def three () 3 end
      
      self.singleton_methods # => ["two", "one"]
      self.class             # => Class
      self                   # => Foo
    end

Two of the three methods defined in the code above are class methods, and therefore go into a singleton class. Left as an exercise for the reader is the inheritance hierarchy for the object that the Foo constant references.

### Test Mocking

Mocking is a popular testing technique that allows you to stub out method calls for an object or class, forcing them to return a specific value or ensuring that they are called a specific number of times. While there are several good mocking libraries available for Ruby, wouldn’t it be nice to know how they work?

In the example below there is a Foo class with two instance methods. The available? method is dependent on the results of the status method. What do you do if you need to verify that the available? method works correctly given the varying results which the status method could return? Mocking and singleton classes to the rescue.

    require 'test/unit'
    
    class Foo
      
      def available?
        status == 1
      end
      
      private
      
      def status
        rand(1)
      end
    end
    
    class FooTest < Test::Unit::TestCase
      def setup
        @foo = Foo.new
      end
    
      def test_available_with_status_1
        def @foo.status () 1 end
        assert(@foo.available?)
      end
      
      def test_available_with_status_0
        def @foo.status () 0 end
        assert(!@foo.available?)
      end
    end

## Conclusion

Understanding the advanced aspects of the Ruby programming language need not be difficult. Hopefully singleton classes make a lot more sense to you now and even seem somewhat useful. You may have missed it but hiding in the text above is also a rather shallow examination of the object system that Ruby employs.

