module RKit::Decorator::ActiveRecordExtend
  attr_accessor :decorator_klass

  def acts_as_decorables base = nil, &block
    define_decorator base || block
    define_instance_methods
  end


  def define_decorator arg
    @decorator_klass = decorator_klass_from arg
  end


  def decorator_klass_from arg
    send "decorator_klass_from_#{ arg.class.name.underscore }", arg
  end

  def decorator_klass_from_nil_class *args
    decorator_klass_from "#{ name }Decorator".constantize
  end

  def decorator_klass_from_class base
    if base <=> RKit::Decorator::Base
      base
    else
      base.tap do |base|
        base.send :include, Module.new{ include refine(RKit::Decorator::Base){} }
        base.extend Module.new{ include refine(RKit::Decorator::Base.singleton_class){} }

        RKit::Decorator::Base.inherited base
      end
    end
  end

  def decorator_klass_from_module mod
    namespace = (mod.name.deconstantize.presence || 'Object').constantize
    const_name = mod.name.demodulize

    namespace.send :remove_const, const_name
    namespace.const_set const_name, Class.new(RKit::Decorator::Base){ include mod }
  end

  def decorator_klass_from_proc block
    (name.deconstantize.presence || 'Object')
      .constantize
      .const_set "#{ name.demodulize }Decorator", Class.new(RKit::Decorator::Base, &block)
  end


  def decorate view_context: nil
    all.map{ |record| record.decorate view_context: view_context }
  end


  def define_instance_methods
    define_method 'decorate' do |view_context: nil|
      self.class.decorator_klass.new self, view_context: view_context
    end
  end


  ActiveRecord::Base.extend self
end
