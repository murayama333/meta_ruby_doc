results = []

results << class A
  def initialize
    @a = 11
    @@a = 22
    a = 33
  end

  @a = 1
  @@a = 2
  a = 3
end

results << A.instance_variable_get(:@a)
results << A.class_variable_get(:@@a)

my_a = A.new
results << my_a.instance_variable_get(:@a)
results << A.class_variable_get(:@@a)
results << my_a.send(:initialize)

results.sort.each {|e| puts e}

