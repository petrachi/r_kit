require 'delegate'

class RKit::Decorator::Base < SimpleDelegator
  alias :_base :__getobj__
  
  def initialize base, view_context, instance_variables = {}
    @view_context = view_context
    
    instance_variables.each do |key, value|
      instance_variable_set "@#{ key }", value
    end
    
    super(base)
  end
  
  def _h
    @view_context
  end
  
  def === object
    self == object || __getobj__ == object
  end
end
