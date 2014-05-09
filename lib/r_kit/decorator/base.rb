require 'delegate'

class RKit::Decorator::Base < SimpleDelegator
  alias :_obj :__getobj__

  def view_context
    backtrace{ |obj| obj.is_a? ActionView::Base } || backtrace{ |obj| obj.respond_to? :view_context }.view_context
  end


  def _h
    @view_context ||= view_context
  end

  def === object
    self == object || __getobj__ == object
  end
end
