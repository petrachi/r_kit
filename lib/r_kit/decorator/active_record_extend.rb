module RKit::Decorator::ActiveRecordExtend
  attr_accessor :decorator_klass

  def acts_as_decorables base = nil, &block
    define_decorator base || block
    define_instance_methods

    include InstanceMethods
  end


  def define_decorator arg
    @decorator_klass = send "decorator_klass_from_#{ arg.class.name.underscore }", arg
  end

  def decorator_klass_from_nil_class *args
    decorator_klass_from_class "#{ name }Decorator".constantize
  end

  def decorator_klass_form_class base
# TODO: auto inheritance if needed
    base
  end

  def decorator_klass_from_proc block
    (name.deconstantize.presence || "Object")
      .constantize
      .const_set "#{ name.demodulize }Decorator", Class.new(RKit::Decorator::Base, &block)
  end


  def define_instance_methods
    define_method "decorate" do |view_context, instance_variables = {}|
      self.class.decorator_klass.new self, view_context, instance_variables
    end
  end


  # TODO: choose -> use that, or use define_method ???
  module InstanceMethods
    def decorate view_context, instance_variables = {}
      self.class.decorator_class.new self, view_context, instance_variables
    end
  end


  ActiveRecord::Base.extend self
end
