module SampleModule
  def square(n)
    n * n
  end
end

class SampleClass
  include SmapleModule
  hoge
end

o = SmapleClass.new
p o.square(3) #=> 9

#not class,use extend

class SampleClass ;end

o = SampleClass.new
o1 = SampleClass.new

o.extend SampleModule
p o.square(3) #=> 9
p o1.square(3) #=> NameError

