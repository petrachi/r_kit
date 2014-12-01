
# Perfs
n = 10_000
t = Time.now
n.times {
  c = Class.new{
    def a() "a" end

    alias :__olddef__a :a
    def a
      __olddef__a << "b"
    end

    def x() "x" end

    alias :__olddef__x :x
    def x
      __olddef__x << "y"
    end
  }
}
p "#{Time.now - t} : perf (x#{n}) - old school using alias"

t = Time.now
n.times {
  c = Class.new{
    def a() "a" end

    override_method :a do
      __olddef__ << "b"
    end

    def x() "x" end

    override_method :x do
      __olddef__ << "y"
    end
  }
}
p "#{Time.now - t} : perf (x#{n}) - override single method (~11x)"

t = Time.now
n.times {
  c = Class.new{
    def a() "a" end
    def x() "x" end

    override_methods do
      def a
        __olddef__ << "b"
      end

      def x
        __olddef__ << "y"
      end
    end
  }
}
p "#{Time.now - t} : perf (x#{n}) - override multiple methods (~11x)"

p "-"
c_basic = Class.new{
  def initialize
    @a = "a"
    @x = "x"
  end

  def a() @a end

  alias :__olddef__a :a
  def a
    __olddef__a << "b"
  end

  def x() @x end

  alias :__olddef__x :x
  def x
    __olddef__x << "y"
  end
}
c_over = Class.new{
  def initialize
    @a = "a"
    @x = "x"
  end

  def a() @a end
  def x() @x end

  override_methods do
    def a
      __olddef__ << "b"
    end

    def x
      __olddef__ << "y"
    end
  end
}
i_basic = c_basic.new
i_over = c_over.new

n = 100_000
t = Time.now
n.times {
  i_basic.a
  i_basic.x
}
p "#{Time.now - t} : perf (x#{n}) - old school method call"

t = Time.now
n.times {
  i_over.a
  i_over.x
}
p "#{Time.now - t} : perf (x#{n}) - override method call (~19x)"
