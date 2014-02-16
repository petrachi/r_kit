module RKit::Decorator::ActiveRecordExtension
  def acts_as_decorables const = nil, &block
    if block_given?
      namespace = name.deconstantize.constantize
      namespace.const_set "#{ name.demodulize }Decorator", Class.new(Decorator::Base, &block)
    end
    
    @const = const || "#{ name }Decorator".constantize
    
    extend ClassMethods
    include InstanceMethods
  end
  
  module ClassMethods
    def decorator_class
      @const
    end
  end
  
  module InstanceMethods
    def decorate view_context, instance_variables = {}
      self.class.decorator_class.new self, view_context, instance_variables
    end
  end
end
