
class A
  def x
    "x"
  end

  override_method :x do
    __olddef__ << "y"
  end
end

# overide classic
puts "A: xy -> #{ A.new.x }"

class B
  def x
    "x"
  end
end

class C < B
  override_method :x do
    __olddef__ << "y"
  end
end

# override w/ inheritance
puts "C: xy -> #{ C.new.x }"

class D
  override_method :x do
    __olddef__ || "y"
  end
end

# override when no previous def
puts "D: y -> #{ D.new.x }"

class E
  def x
    "x"
  end

  override_method :x do
    __olddef__ << "y"
  end

  override_methods do
    def x
      __olddef__ << "z"
    end
  end
end

# override many
puts "E: xyz -> #{ E.new.x }"

class F < B
  def a
    "a"
  end

  override_methods do
    def a
      __olddef__ << "b"
    end

    def x
      __olddef__ << "y"
    end
  end
end

# multi override don't collapse
f = F.new
puts "F: ab -> #{ f.a }"
puts "F: xy -> #{ f.x }"
puts "F: ab -> #{ f.a }"
puts "F: xy -> #{ f.x }"


class G
  def initialize(s)
    @s = s
  end

  def should?
   @s
  end

  def x
    "x"
  end

  depend_pattern = ->{
    if should?
      __newdef__
    else
      nil
    end
  }

  override_method :x, pattern: depend_pattern do
    __olddef__ << "y"
  end
end

# override w/ depend pattern
puts "G:  -> #{ G.new(false).x }"
puts "G: xy -> #{ G.new(true).x }"

class H
  def x(str)
    "x" << str
  end

  override_method :x do |str, str_end|
    __olddef__(str) << "y" << str_end
  end
end

# override w/ args
puts "H: xXyY -> #{ H.new.x('X', 'Y') }"

class I
  def x(str)
    "x" << str
  end

  override_methods do
    def x(str, str_end)
      __olddef__(str) << "y" << str_end
    end
  end
end

# override many w/ args
puts "I: xXyY -> #{ I.new.x('X', 'Y') }"

class J
  def initialize(s)
    @s = s
  end

  def should?
   @s
  end

  def x
    "x"
  end

  if_pattern = ->{
    if should?
      __newdef__
    else
      __olddef__
    end
  }

  override_method :x, pattern: if_pattern do
    __olddef__ << "y"
  end
end

# override w/ if pattern
puts "J: x -> #{ J.new(false).x }"
puts "J: xy -> #{ J.new(true).x }"

class K < SimpleDelegator
  override_method :x do
    __olddef__ << "y"
  end
end

# override in delegator
puts "K: xy -> #{ K.new(B.new).x }"

class L
  def initialize
    @should_load = true
  end

  def load
    "not implemented"
  end

  override_method :load do
    if @should_load
      @should_load = false
      "load"
    else
      "nothing"
    end
  end
end

# change instance values inside overrided method
l = L.new
puts "L: load -> #{ l.load }"
puts "L: nothing -> #{ l.load }"

class M
  def initialize
    @loaded = false
  end

  def loaded?
    @loaded
  end

  def load
    "not implemented"
  end

  override_method :load do
    @loaded = true
    self
  end
end

# return self in overrided method
puts "M: false -> #{ M.new.loaded? }"
puts "M: true -> #{ M.new.load.loaded? }"

class N
  class << self
    def x
      "x"
    end

    override_method :x do
      __olddef__ << "y"
    end
  end
end

# override singleton method using '<<' syntax
puts "N: xy -> #{ N.x }"

class O
  def self.x
    "x"
  end

  override_methods do
    def self.x
      __olddef__ << "y"
    end
  end
end

# override singleton method using 'self.' syntax
puts "O: xy -> #{ O.x }"

class P < SimpleDelegator
  def initialize(obj, should)
    super(obj)
    @should = should
  end

  if_pattern = ->{
    if @should
      __newdef__
    else
      __olddef__
    end
  }

  override_method :x, pattern: if_pattern do
    __olddef__ << "y"
  end
end

# override in delegator w/ if pattern
puts "P: x -> #{ P.new(B.new, false).x }"
puts "P: xy -> #{ P.new(B.new, true).x }"

module Q
  override_method :x do
    __olddef__ << "y" rescue 'hahah'
  end
end

class R
  prepend Q

  def x
    "x"
  end
end

# override in a prepended module from a class
puts "R: xy -> #{ (r = R.new).x }"
puts "R: xy -> #{ r.x }"

module S
  def x
    "x"
  end
end

class T

  override_method :x do
    __olddef__ << "y"
  end

  include S

end

# override in a included module from a class
puts "T: xy -> #{ (t = T.new).x }"
puts "T: xy -> #{ t.x }"

class U < SimpleDelegator
  override_method :x do
    __olddef__ || 'y'
  end
end

# delegate w/ no previous def in delegated object
puts "U: y -> #{ U.new(Class.new.new).x }"

class V
  def self.x
    "x"
  end

  override_singleton_method :x do
    __olddef__ << "y"
  end
end

# override singleton method w/ specific method
puts "V: xy -> #{ V.x }"

class W
  def self.x
    "x"
  end

  override_singleton_methods do
    def x
      __olddef__ << "y"
    end
  end
end

# override singleton methods w/ specific method
puts "W: xy -> #{ W.x }"

class X
  def self.x
    "x"
  end

  override_singleton_method :x do
    __olddef__ << "y"
  end

  override_singleton_methods do
    def x
      __olddef__ << "z"
    end
  end
end

# override many in singleton
puts "X: xyz -> #{ X.x }"

class Y
  def self.a
    "a"
  end

  def self.x
    "x"
  end

  override_singleton_methods do
    def a
      __olddef__ << "b"
    end

    def x
      __olddef__ << "y"
    end
  end
end

# multi singleton override don't collapse
puts "Y: ab -> #{ Y.a }"
puts "Y: xy -> #{ Y.x }"
puts "Y: ab -> #{ Y.a }"
puts "Y: xy -> #{ Y.x }"


class Z
  def self.meta_x method_name_1
    singleton_class.send :define_method, method_name_1 do
      # p method_name_1.object_id
      method_name_1
    end
  end

  override_singleton_method :meta_x do |name|

    __olddef__(name).tap do |method_name_2|

      override_singleton_method method_name_2 do
        # p __olddef__.object_id
        __olddef__ << method_name_2.to_s
      end
    end
  end

  meta_x 'x'
  meta_x 'y'
  meta_x 'z'

end

# overide nested
puts "Z: xx -> #{ Z.x }"
puts "Z: yy -> #{ Z.y }"
puts "Z: zz -> #{ Z.z }"
puts "!Z: xx -> #{ Z.x }"
puts "!Z: yy -> #{ Z.y }"
puts "!Z: zz -> #{ Z.z }"
puts "NOTE: this behavior is because `__olddef__' (the nested one) get as a result `method_name_1'"
puts "NOTE: as `method_name_1' is actually a local variable, it is passed as a reference, so it will be modified"
puts "NOTE: as `method_name_1' is modified, it will change the behavior of `__olddef__'"
puts "NOTE: see below a correct implementation of this"

class Z2
  def self.meta_x method_name_1
    singleton_class.send :define_method, method_name_1 do
      method_name_1.dup
    end
  end

  override_singleton_method :meta_x do |name|

    __olddef__(name).tap do |method_name_2|

      override_singleton_method method_name_2 do
        __olddef__ << method_name_2.to_s
      end
    end
  end

  meta_x 'x'
  meta_x 'y'
  meta_x 'z'

end

# overide nested
puts "Z: xx -> #{ Z2.x }"
puts "Z: yy -> #{ Z2.y }"
puts "Z: zz -> #{ Z2.z }"
puts "Z: xx -> #{ Z2.x }"
puts "Z: yy -> #{ Z2.y }"
puts "Z: zz -> #{ Z2.z }"
