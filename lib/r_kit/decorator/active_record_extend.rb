module RKit::Decorator::ActiveRecordExtend

  attr_accessor :decorator_klass

  def acts_as_decorables base = nil, &block
    define_decorator base || block
    define_instance_methods
  end

  # TODO: all the methods below this comment should be private, even more, they should be in a "decorator_finder_creator_definer", and not included in active_record. SRP guys !
  def define_decorator arg
    @decorator_klass = decorator_klass_from arg
    @decorator_klass
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
        base.instance_variable_set "@decorated_klass", self
        base.class_eval{ alias :"#{ decorated_klass.demodulize.underscore }" :__getobj__ }
      end
    end
  end

  def decorator_klass_from_module mod
    namespace = (mod.name.deconstantize.presence || 'Object').constantize
    const_name = mod.name.demodulize

    namespace.send :remove_const, const_name
    namespace.const_set const_name, RKit::Decorator::Class.new(self){ include mod }
  end

  def decorator_klass_from_proc block
    (name.deconstantize.presence || 'Object')
      .constantize
      .const_set "#{ name.demodulize }Decorator", RKit::Decorator::Class.new(self, &block)
  end

  # TODO: this couls move in "ennumerable", cause if the AR::relation is mapped into an array
  # or if we create an array with decorables objects in it
  # this will fail
  # --
  # in addition, make a "safe_decorate" for collections, wich will decorate if respond_to_decorate,
  # and will not raise error
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
