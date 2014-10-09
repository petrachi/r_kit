class RKit::Decoration::Class

  class << self
    alias :basic_new :new
    def new *args, &block
      basic_new(*args, &block).decorator
    end
  end


  def initialize decorated, from: nil, &block
    @decorated = decorated
    @from = from
    @block = block || proc{}
  end


  def decorator
    decorator_from(@from)
      .tap{ |decorator| decorator.instance_variable_set "@decorated_class", @decorated }
      .tap{ |decorator| decorator.class_eval{ alias :"#{ decorated_class.demodulize.underscore }" :__getobj__ } }
      .tap{ |decorator| decorator.class_eval &@block }
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
        .const_get name, default: Class.new(RKit::Decoration::Object)
    )
  end

  alias :decorator_from_symbol :decorator_from_string

  # TODO: method module_to_class(superclass)
  def decorator_from_module mod
    mod
      .namespace
      .const_replace mod.demodulize,
        Class.new(RKit::Decoration::Object){ include mod }
  end

  def decorator_from_class base
    if base <=> RKit::Decoration::Object
      base
    else
      # TODO: method class_to_module
      # TODO: method class.add_ancestor(superclass)
      base.tap do |base|
        base.send :include, Module.new{ include refine(RKit::Decoration::Object){} }
        base.extend Module.new{ include refine(RKit::Decoration::Object.singleton_class){} }
        base.instance_variable_set "@decorated_class", @decorated
        base.class_eval{ alias :"#{ decorated_class.demodulize.underscore }" :__getobj__ }
      end
    end
  end
end


# # TODO: all the methods below this comment should be private, even more, they should be in a "decorator_finder_creator_definer", and not included in active_record. SRP guys !
# def define_decorator arg
#   @decorator_klass = decorator_klass_from arg
#   @decorator_klass
# end
#
#
# def decorator_klass_from arg
#   send "decorator_klass_from_#{ arg.class.name.underscore }", arg
# end
#
# def decorator_klass_from_nil_class *args
#   decorator_klass_from "#{ name }Decorator".constantize
# end
#
# def decorator_klass_from_class base
#   if base <=> RKit::Decoration::Base
#     base
#   else
#     base.tap do |base|
#       base.send :include, Module.new{ include refine(RKit::Decoration::Base){} }
#       base.extend Module.new{ include refine(RKit::Decoration::Base.singleton_class){} }
#       base.instance_variable_set "@decorated_klass", self
#       base.class_eval{ alias :"#{ decorated_klass.demodulize.underscore }" :__getobj__ }
#     end
#   end
# end
#
# def decorator_klass_from_module mod
#   namespace = (mod.name.deconstantize.presence || 'Object').constantize
#   const_name = mod.name.demodulize
#
#   namespace.send :remove_const, const_name
#   namespace.const_set const_name, RKit::Decoration::Class.new(self){ include mod }
# end
#
# def decorator_klass_from_proc block
#   (name.deconstantize.presence || 'Object')
#     .constantize
#     .const_set "#{ name.demodulize }Decorator", RKit::Decoration::Class.new(self, &block)
# end
