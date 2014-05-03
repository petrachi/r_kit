require 'delegate'

class RKit::Decorator::Base < SimpleDelegator
  alias :_obj :__getobj__

  def initialize object, view_context, assigns = {}
    # TODO: view context will be auto-detect
    @view_context = view_context
    assign assigns

    super object
  end

  def assign assigns
    assigns.each do |key, value|
      instance_variable_set "@#{ key }", value
    end
  end


  def _h
    @view_context
  end

  def === object
    self == object || __getobj__ == object
  end
end
