class RKit::Decoration::Class

  def self.new *args, &block
    super.decorator
  end


  def initialize decorated, from: nil, sleeping: nil, &block
    @decorated = decorated
    @from = from
    @sleeping = sleeping
    @block = block || proc{}
  end


  def decorator
    decorator_from(@from)
      .tap{ |decorator| decorator.instance_variable_set "@decorated_class", @decorated }
      .tap{ |decorator| decorator.class_eval{ alias :"#{ decorated_class.demodulize.underscore }" :__getobj__ } }
      .tap{ |decorator| decorator.send :include, @sleeping }
      .tap{ |decorator| decorator.class_eval &@block }
  end


  def decorator_superclass
    if @decorated <=> Enumerable
      RKit::Decoration::Collection
    else
      RKit::Decoration::Object
    end
  end



  protected def decorator_from from
    send "decorator_from_#{ from.class.underscore }", from
  end


  protected def decorator_from_nil_class *_
    decorator_from "#{ @decorated.demodulize }Decorator"
  end

  protected def decorator_from_string name
    decorator_from(
      @decorated
        .namespace
        .const_get name, default: Class.new(decorator_superclass)
    )
  end

  alias :decorator_from_symbol :decorator_from_string

  # TODO: method module_to_class(superclass)
  def decorator_from_module mod
    mod
      .namespace
      .const_replace mod.demodulize,
        Class.new(decorator_superclass){ include mod }
  end

  def decorator_from_class base
    if base <=> RKit::Decoration::Base
      base
    else
      # TODO: method class_to_module
      # TODO: method class.add_ancestor(superclass)
      decorator_superclass = self.decorator_superclass

      base.tap do |base|
        base.send :include, Module.new{ include refine(decorator_superclass){} }
        base.extend Module.new{ include refine(decorator_superclass.singleton_class){} }
        base.instance_variable_set "@decorated_class", @decorated
        base.class_eval{ alias :"#{ decorated_class.demodulize.underscore }" :__getobj__ }
      end
    end
  end
end
